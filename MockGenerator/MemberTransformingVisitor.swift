import Foundation

import MockGenerating

import class AST.RecursiveElementVisitor
import protocol AST.Element
import protocol AST.ArrayType
import protocol AST.DictionaryType
import protocol AST.OptionalType
import protocol AST.`Type`
import protocol AST.TypeIdentifier
import protocol AST.FunctionType
import protocol AST.ParenthesizedType
import protocol AST.MetatypeType
import protocol AST.TupleType
import protocol AST.TupleTypeElement
import protocol AST.FunctionDeclaration
import protocol AST.Declaration
import protocol AST.Parameter
import protocol AST.ParameterClause
import protocol AST.VariableDeclaration
import protocol AST.GetterSetterDeclaration
import protocol AST.InitializerDeclaration
import protocol AST.SubscriptDeclaration
import protocol AST.FunctionTypeArgumentClause
import protocol AST.FunctionTypeArgument
import protocol AST.LeafNode
import protocol AST.Attributes
import protocol AST.DeclarationModifier
import protocol AST.CodeBlock
import protocol AST.GetterSetterBlock
import protocol AST.GetterSetterKeywordBlock
import protocol AST.Initializer
import protocol SwiftyKit.Resolver

class MemberTransformingVisitor: RecursiveElementVisitor {

    private(set) var initializers = [MockGenerating.Initializer]()
    private(set) var properties = [MockGenerating.Property]()
    private(set) var methods = [MockGenerating.Method]()
    private(set) var subscripts = [MockGenerating.Subscript]()
    private(set) var type: MockGenerating.`Type` = MockGenerating.TypeIdentifier.Builder(identifier: "").build()
    private let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }

    static func transformType(_ element: AST.Element, resolver: Resolver) -> MockGenerating.`Type` {
        let visitor = MemberTransformingVisitor(resolver: resolver)
        element.accept(visitor)
        return visitor.type
    }

    func transformType(_ element: AST.Element) -> MockGenerating.`Type` {
        return MemberTransformingVisitor.transformType(element, resolver: resolver)
    }

    override func visitType(_ element: AST.`Type`) {
        type = MockGenerating.TypeIdentifier(identifier: element.text)
    }

    override func visitTypeIdentifier(_ element: AST.TypeIdentifier) {
        if let genericArgumentClause = element.genericArgumentClause {
            type = GenericType(identifier: element.typeName, arguments: genericArgumentClause.arguments.map { transformType($0) })
        } else {
            let identifiers = element.typeNames
            type = MockGenerating.TypeIdentifier(identifiers: identifiers)
        }
    }

    override func visitArrayType(_ element: AST.ArrayType) {
        type = MockGenerating.ArrayType(type: transformType(element.elementType), useVerboseSyntax: false)
    }

    override func visitDictionaryType(_ element: AST.DictionaryType) {
        let key = transformType(element.keyType)
        let value = transformType(element.valueType)
        type = MockGenerating.DictionaryType(keyType: key, valueType: value, useVerboseSyntax: false)
    }

    override func visitOptionalType(_ element: AST.OptionalType) {
        let iuo = element.text.hasSuffix("!")
        let type = transformType(element.type)
        self.type = MockGenerating.OptionalType(type: type, isImplicitlyUnwrapped: iuo, useVerboseSyntax: false)
    }

    override func visitFunctionType(_ element: AST.FunctionType) {
        type = MockGenerating.FunctionType(
            arguments: element.functionTypeArgumentClause.arguments
                .compactMap { $0.typeAnnotation?.type ?? $0.type
                }
            .map { transformType($0) },
            returnType: transformType(element.returnType),
            async: element.async,
            throws: element.throws
        )
    }

    override func visitParenthesizedType(_ element: ParenthesizedType) {
        let tupleType = MockGenerating.TupleType.TupleElement(
            label: nil,
            type: transformType(element.type)
        )
        type = MockGenerating.TupleType(tupleElements: [tupleType])
    }

    override func visitMetatypeType(_ element: MetatypeType) {
        type = MockGenerating.TypeIdentifier(identifiers: [element.type.text, element.metatype.text])
    }

    override func visitTupleType(_ element: AST.TupleType) {
        let tupleElements = element.tupleTypeElementList.tupleTypeElements.compactMap(transformTupleType)
        type = MockGenerating.TupleType(tupleElements: tupleElements)
    }

    private func transformTupleType(_ e: TupleTypeElement) -> MockGenerating.TupleType.TupleElement? {
        if let type = e.type ?? e.typeAnnotation?.type {
            return MockGenerating.TupleType.TupleElement(label: e.elementName?.text, type: transformType(type))
        }
        return nil
    }

    override func visitFunctionDeclaration(_ element: FunctionDeclaration) {
        guard isOverridable(element) else {
            return
        }
        methods.append(transform(element))
        super.visitFunctionDeclaration(element)
    }

    private func isOverridable(_ element: Declaration) -> Bool {
        return !element.hasPrivateModifier
               && !element.hasFilePrivateModifier
               && !element.isStatic
               && !element.hasClassDeclarationModifier
               && !element.isFinal
    }

    private func transform(_ element: FunctionDeclaration) -> MockGenerating.Method {
        let genericParameter = transformGenericParameters(from: element)
        let parameters = transformParameters(element.parameterClause.parameters)
        let returnType = element.functionResult.map { transformType($0.type) } ?? MockGenerating.TypeIdentifier(identifier: "")
        return MockGenerating.Method(
            name: element.name,
            genericParameters: genericParameter,
            returnType: MockGenerating.ResolvedType(originalType: returnType, resolvedType: returnType),
            parametersList: parameters,
            declarationText: getDeclarationText(element),
            async: element.async,
            throws: element.throws,
            rethrows: element.rethrows
        )
    }

    private func getDeclarationText(_ element: AST.Element) -> String {
        let visitor = DeclarationTextVisitor()
        element.accept(visitor)
        return visitor.text.trimmingCharacters(in: .whitespaces)
    }

    private func transformGenericParameters(from element: FunctionDeclaration) -> [String] {
        return element.genericParameterClause?.parameters.map { param in
            param.name
        } ?? []
    }

    private func transformParameters(_ parameters: [AST.Parameter]) -> [MockGenerating.Parameter] {
        return parameters.map { parameter in
            var internalName = parameter.localParameterName
            if internalName == "`let`" {
                internalName = "let"
            } else if internalName == "`var`" {
                internalName = "var"
            }
            return MockGenerating.Parameter(
                externalName: parameter.externalParameterName,
                internalName: internalName,
                type: MockGenerating.ResolvedType(originalType: transformType(parameter.typeAnnotation.type), resolvedType: resolveAndTransform(parameter.typeAnnotation.type)),
                text: parameter.text,
                isEscaping: isEscaping(parameter))
        }
    }

    private func isEscaping(_ parameter: AST.Parameter) -> Bool {
        return parameter.typeAnnotation.attributes.attributes.contains { $0.text == "@escaping" }
    }

    private func resolveAndTransform(_ type: AST.`Type`) -> MockGenerating.`Type` {
        let resolved = resolveType(type)
        return transformType(resolved)
    }

    private func resolveType(_ type: AST.`Type`) -> AST.`Type` {
        let visitor = TypeResolverVisitor(resolver: resolver)
        type.accept(visitor)
        return visitor.resolvedType ?? type
    }

    override func visitVariableDeclaration(_ element: VariableDeclaration) {
        guard isOverridable(element) && isPropertyOverridable(element),
              let name = element.name,
              let type = findType(element) else {
            return
        }
        let typeAnnotation = element.typeAnnotation == nil ? ": \(type.text)" : ""
        properties.append(MockGenerating.Property(name: name,
            type: type,
            isWritable: isWritable(element),
            declarationText: "var \(getDeclarationText(element.patternInitializerList.patternInitializers[0]))\(typeAnnotation)"))
    }

    private func findType(_ element: VariableDeclaration) -> MockGenerating.`Type`? {
        if let type = element.typeAnnotation?.type {
            return transformType(type)
        } else if let type = VariableTypeResolver.resolve(element, resolver: resolver) {
            return type
        }
        return nil
    }

    private func isWritable(_ element: GetterSetterDeclaration) -> Bool {
        if element.isSetPrivate || element.isSetFilePrivate {
            return false
        } else if element.getterSetterKeywordBlock?.setterKeywordClause != nil {
            return true
        } else if element.getterSetterBlock?.setterClause != nil {
            return true
        }
        return (element.getterSetterKeywordBlock == nil
                && element.getterSetterBlock == nil
                && element.codeBlock == nil)
    }

    private func isPropertyOverridable(_ element: VariableDeclaration) -> Bool {
        return !element.isConstant
    }

    override func visitInitializerDeclaration(_ element: InitializerDeclaration) {
        guard isOverridable(element) else {
            return
        }
        initializers.append(
            MockGenerating.Initializer(
                parametersList: transformParameters(element.parameterClause.parameters),
                isFailable: element.isFailable,
                async: element.async,
                throws: element.throws
            )
        )
    }

    override func visitSubscriptDeclaration(_ element: SubscriptDeclaration) {
        guard isOverridable(element),
            let functionResult = element.functionResult else {
            return
        }
        let returnType = transformType(functionResult.type)
        let resolvedType = MockGenerating.ResolvedType(originalType: returnType, resolvedType: returnType)
        subscripts.append(
            MockGenerating.Subscript(
                returnType: resolvedType,
                parameters: transformParameters(element.parameterClause.parameters),
                isWritable: isWritable(element),
                declarationText: getDeclarationText(element)
            )
        )
    }
}

extension ParameterClause {

    var parameters: [AST.Parameter] {
        return parameterList?.parameters ?? []
    }
}


extension FunctionTypeArgumentClause {

    var arguments: [FunctionTypeArgument] {
        return functionTypeArgumentList?.arguments ?? []
    }

}

private class DeclarationTextVisitor: RecursiveElementVisitor {
    var text = ""

    override func visitLeafNode(_ element: LeafNode) {
        text += element.text
    }

    override func visitParameterClause(_ element: ParameterClause) {
        // attributes are allowed in here
        text += element.text
    }

    // These elements are ignored
    override func visitAttributes(_ element: Attributes) {}
    override func visitDeclarationModifier(_ element: DeclarationModifier) {}
    override func visitCodeBlock(_ element: CodeBlock) {}
    override func visitGetterSetterBlock(_ element: GetterSetterBlock) {}
    override func visitGetterSetterKeywordBlock(_ element: GetterSetterKeywordBlock) {}
    override func visitInitializer(_ element: AST.Initializer) {}
}
