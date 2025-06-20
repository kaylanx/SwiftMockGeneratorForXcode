//
//  MockViewPresenter.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

class MockViewPresenter: MockTransformer {

    private let view: MockView

    private var protocolMethods: [Method] = []
    private var protocolProperties: [Property] = []
    private var protocolSubscripts: [Subscript] = []
    private var classMethods: [Method] = []
    private var classProperties: [Property] = []
    private var classSubscripts: [Subscript] = []
    private var classInitializer: Initializer?
    private var initializers: [Initializer] = []
    private var scope: String?
    private var nameGenerator: UniqueMethodNameGenerator!

    init(view: MockView) {
        self.view = view
    }

    func set(scope: String) {
        self.scope = scope.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func add(method: Method) {
        protocolMethods.append(method)
    }

    func add(property: Property) {
        protocolProperties.append(property)
    }

    func add(subscript: Subscript) {
        protocolSubscripts.append(`subscript`)
    }

    func add(initializers: Initializer...) {
        add(initializers: initializers)
    }

    func add(methods: Method...) {
        self.add(methods: methods)
    }

    func add(properties: Property...) {
        self.add(properties: properties)
    }

    func add(subscripts: Subscript...) {
        self.add(subscripts: subscripts)
    }

    func add(initializers: [Initializer]) {
        self.initializers.append(contentsOf: initializers)
    }

    func add(methods: [Method]) {
        self.protocolMethods.append(contentsOf: methods)
    }

    func add(properties: [Property]) {
        self.protocolProperties.append(contentsOf: properties)
    }

    func add(subscripts: [Subscript]) {
        self.protocolSubscripts.append(contentsOf: subscripts)
    }

    func set(classInitializers: Initializer...) {
        set(classInitializers: classInitializers)
    }

    func set(classInitializers: [Initializer]) {
        self.classInitializer = classInitializers.min(by: { $0.parametersList.count < $1.parametersList.count })
    }

    func add(classMethods: Method...) {
        self.classMethods.append(contentsOf: classMethods)
    }

    func add(classMethods: [Method]) {
        self.classMethods.append(contentsOf: classMethods)
    }

    func add(classProperties: Property...) {
        self.classProperties.append(contentsOf: classProperties)
    }

    func add(classProperties: [Property]) {
        self.classProperties.append(contentsOf: classProperties)
    }

    func add(classSubscripts: Subscript...) {
        self.classSubscripts.append(contentsOf: classSubscripts)
    }

    func add(classSubscripts: [Subscript]) {
        self.classSubscripts.append(contentsOf: classSubscripts)
    }

    @discardableResult
    func generate() -> String {
        generateOverloadedNames()
        let mockModel = MockViewModel(
            initializer: transformInitializers(),
            property: transformProperties(),
            method: transformMethods(),
            subscript: transformSubscripts(),
            scope: scope
        )
        view.render(model: mockModel)
        return ""
    }

    private func transformInitializers() -> [InitializerViewModel] {
        transformClassInitializer() + transformProtocolInitializer()
    }

    private func transformProtocolInitializer() -> [InitializerViewModel] {
        initializers.map {
            InitializerViewModel(
                declarationText: SwiftStringProtocolInitialiserDeclaration().transform(initializer: $0),
                initializerCall: ""
            )
        }
    }

    private func transformClassInitializer() -> [InitializerViewModel] {
        guard let classInitializer else { return [] }
        let call = flatMap(value: classInitializer) { CreateConvenienceInitialiser().transform(initializer: $0) }
        guard let call, let call else { return [] }

        let scope = getClassInitializerScope()
        return [
            InitializerViewModel(
                declarationText: scope + SwiftStringInitialiserDeclaration().transform(call: call),
                initializerCall: SwiftStringConvenienceInitCall().transform(call: call)
            )
        ]
    }

    private func flatMap<T, R>(value: T?, transform: (T) -> R) -> R? {
        guard let value = value else { return nil }
        return transform(value)
    }

    private func getClassInitializerScope() -> String {
        switch scope {
        case "open": return "public "
        case let scope?: return "\(scope) "
        default: return ""
        }
    }

    private func generateOverloadedNames() {
        let allProtocolProperties = protocolProperties.map { $0.toMethodModel() }
        let allProtocolMethods = protocolMethods.map { $0.toMethodModel() }
        let allProtocolSubscripts = protocolSubscripts.map { $0.toMethodModel() }
        let allClassMethods = classMethods.map { $0.toMethodModel() }
        let allClassProperties = classProperties.map { $0.toMethodModel() }
        let allClassSubscripts = classSubscripts.map { $0.toMethodModel() }

        let all = allProtocolProperties + allProtocolMethods + allProtocolSubscripts +
        allClassMethods + allClassProperties + allClassSubscripts

        nameGenerator = UniqueMethodNameGenerator(methodModels: all)
        nameGenerator.generateMethodNames()
    }


    private func transformProperties() -> [PropertyViewModel] {
        transformProperties(classProperties, isClass: true) + transformProperties(protocolProperties, isClass: false)
    }

    private func transformProperties(
        _ properties: [Property],
        isClass: Bool
    ) -> [PropertyViewModel] {
        properties.map {
            let name = getUniqueName($0).capitalizingFirstLetter()
            let optionalized = OptionalizeIUOVisitor.optionalize(type: $0.type)
            let removedOptional = RemoveOptionalVisitor.remove(optionalType: $0.type)
            let removedRecursive = RecursiveRemoveOptionalVisitor.remove(optionalType: $0.type)
            let assignment = DefaultValueVisitor.getDefaultValue(
                for: $0.type
            ) != "nil" ? "= \(DefaultValueVisitor.getDefaultValue(for: $0.type)!)" : ""
            return PropertyViewModel(
                name: $0.name,
                capitalizedUniqueName: name,
                hasSetter: $0.isWritable,
                type: optionalized.text,
                optionalType: SurroundOptionalVisitor
                    .surround(type: removedOptional, unwrapped: false).text,
                iuoType: SurroundOptionalVisitor
                    .surround(type: removedRecursive, unwrapped: true).text,
                defaultValueAssignment: assignment,
                defaultValue: DefaultValueVisitor.getDefaultValue(for: $0.type),
                isImplemented: isClass,
                declarationText: transformDeclarationText(
                    declaration: $0.getTrimmedDeclarationText(),
                    isOverriding: isClass
                )
            )
        }
    }

    private func getUniqueName(_ method: Method) -> String {
        nameGenerator.getMethodName(for: method.toMethodModel().id) ?? ""
    }

    private func getUniqueName(_ property: Property) -> String {
        nameGenerator.getMethodName(for: property.toMethodModel().id) ?? ""
    }

    private func getUniqueName(_ subscript: Subscript) -> String {
        nameGenerator.getMethodName(for: `subscript`.toMethodModel().id) ?? ""
    }

    private func transformDeclarationText(declaration: String, isOverriding: Bool) -> String {
        var modifiers = ""
        if let scope = scope { modifiers += scope + " " }
        if isOverriding { modifiers += "override " }
        return modifiers + declaration
    }

    private func transformMethods() -> [MethodViewModel] {
        transformMethods(classMethods, isClass: true) +
            transformMethods(protocolMethods, isClass: false)
    }

    private func transformMethods(_ methods: [Method], isClass: Bool) -> [MethodViewModel] {
        methods.map {
            MethodViewModel(
                capitalizedUniqueName: getUniqueName($0).capitalizingFirstLetter(),
                escapingParameters: transformParameters($0),
                closureParameter: $0.parametersList.compactMap(transformClosureParameters),
                resultType: transformReturnType($0),
                functionCall: MakeFunctionCallVisitor.make(element: $0),
                async: $0.async,
                throws: $0.throws,
                rethrows: $0.rethrows,
                isImplemented: isClass,
                declarationText:  transformDeclarationText(
                    declaration: $0.declarationText.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ),
                    isOverriding: isClass
                )
            )
        }
    }

    private func transformClosureParameters(_ parameter: Parameter) -> ClosureParameterViewModel? {
        let visitor = FunctionParameterTransformer(name: parameter.internalName)
        parameter.type.resolvedType.accept(visitor: visitor)
        return visitor.transformed
    }

    private func transformReturnType(_ method: Method) -> ResultTypeViewModel? {
        guard !TypeIdentifiers.isEmpty(method.returnType.resolvedType) else { return nil }
        return transformReturnType(method.returnType, genericParameters: method.genericParameters)
    }

    private func transformReturnType(_ type: ResolvedType, genericParameters: [String]) -> ResultTypeViewModel {
        let erased = erase(type.originalType, genericParameters)
        return ResultTypeViewModel(
            defaultValueAssignment: getDefaultValueAssignment(type.resolvedType),
            defaultValue: getDefaultValue(type.resolvedType),
            optionalType: SurroundOptionalVisitor.surround(type: RemoveOptionalVisitor.remove(optionalType: erased), unwrapped: false).text,
            iuoType: SurroundOptionalVisitor.surround(type: RecursiveRemoveOptionalVisitor.remove(optionalType: erased), unwrapped: true).text,
            type: OptionalizeIUOVisitor.optionalize(type: erased).text,
            returnCastStatement: transformReturnCastStatement(originalType: type.originalType, erasedType: erased)
        )
    }

    private func erase(_ type: `Type`, _ genericParameters: [String]) -> `Type` {
        let copied = copy(type)
        TypeErasingVisitor(genericIdentifiers: genericParameters)
            .visit(type: copied)
        return copied
    }

    private func copy(_ type: `Type`) -> `Type` {
        let visitor = CopyVisitor()
        type.accept(visitor: visitor)
        return visitor.copy
    }

    private func transformReturnCastStatement(originalType: `Type`, erasedType: `Type`) -> String {
        guard originalType.text != erasedType.text else { return "" }
        let optional = originalType is OptionalType ? "?" : "!"
        let typeName = (originalType is OptionalType) ? RemoveOptionalVisitor.remove(optionalType: originalType).text : originalType.text
        return " as\(optional) \(typeName)"
    }

    private func getDefaultValueAssignment(_ type: `Type`) -> String {
        guard let defaultValue = DefaultValueVisitor.getDefaultValue(for: type), defaultValue != "nil" else {
            return ""
        }
        return "= \(defaultValue)"
    }

    private func getDefaultValue(_ type: Type) -> String? {
        DefaultValueVisitor.getDefaultValue(for: type)
    }

    private func transformParameters(_ method: Method) -> ParametersViewModel? {
        transformParameters(method.parametersList, genericParameters: method.genericParameters)
    }

    private func transformParameters(_ parametersList: [Parameter], genericParameters: [String]) -> ParametersViewModel? {
        let declaration = CreateInvokedParameters().transform(
            parameterList: parametersList,
            genericIdentifiers: genericParameters
        )
        guard let declaration else { return nil }
        let assignment = SwiftStringTupleForwardCall().transform(property: declaration)

        return ParametersViewModel(
            tupleRepresentation: declaration.text,
            tupleAssignment: assignment
        )
    }

    private func transformSubscripts() -> [SubscriptViewModel] {
        transformSubscripts(classSubscripts, isClass: true) +
            transformSubscripts(protocolSubscripts, isClass: false)
    }

    private func transformSubscripts(_ subscripts: [Subscript], isClass: Bool) -> [SubscriptViewModel] {
        subscripts.map {
            SubscriptViewModel(
                capitalizedUniqueName: getUniqueName($0).capitalizingFirstLetter(),
                escapingParameters: transformParameters($0.parameters, genericParameters: []),
                hasSetter: $0.isWritable,
                resultType: transformReturnType(
                    $0.returnType,
                    genericParameters: []
                ),
                functionCall: MakeFunctionCallVisitor.make(element: $0),
                isImplemented: isClass,
                declarationText: transformDeclarationText(
                    declaration: $0.declarationText,
                    isOverriding: isClass
                )
            )
        }
    }
}

fileprivate extension Method {
    func toMethodModel() -> MethodModel {
        MethodModel(methodName: name, paramLabels: parametersList)
    }
}

fileprivate extension Property {
    func toMethodModel() -> MethodModel {
        MethodModel(methodName: name, paramLabels: "")
    }
}

fileprivate extension Subscript {
    func toMethodModel() -> MethodModel {
        MethodModel(methodName: "subscript", paramLabels: parameters)
    }
}
