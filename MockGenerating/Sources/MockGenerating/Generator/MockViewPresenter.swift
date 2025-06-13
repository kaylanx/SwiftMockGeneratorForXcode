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
            property: [], // transformProperties(),
            method: transformMethods(),
            subscript: [], // transformSubscripts(),
            scope: scope
        )
        view.render(model: mockModel)
        return ""
    }

    private func transformInitializers() -> [InitializerViewModel] {
        return transformClassInitializer() + transformProtocolInitializer()
    }

    private func transformProtocolInitializer() -> [InitializerViewModel] {
        return initializers.map {
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


//    private func transformProperties() -> [PropertyViewModel] {
//        return transformProperties(classProperties, isClass: true) +
//        transformProperties(protocolProperties, isClass: false)
//    }
//
//    private func transformProperties(_ properties: [Property], isClass: Bool) -> [PropertyViewModel] {
//        return properties.map {
//            let name = getUniqueName($0).capitalized
//            let optionalized = OptionalizeIUOVisitor.optionalize($0.type)
//            let removedOptional = RemoveOptionalVisitor.removeOptional($0.type)
//            let removedRecursive = RecursiveRemoveOptionalVisitor.removeOptional($0.type)
//            let assignment = DefaultValueVisitor.getDefaultValue($0.type) != "nil" ? "= \(DefaultValueVisitor.getDefaultValue($0.type)!)" : ""
//            return PropertyViewModel(
//                name: $0.name,
//                capitalizedName: name,
//                isWritable: $0.isWritable,
//                originalType: optionalized.text,
//                unwrappedType: SurroundOptionalVisitor.surround(removedOptional, unwrapped: false).text,
//                deeplyUnwrappedType: SurroundOptionalVisitor.surround(removedRecursive, unwrapped: true).text,
//                defaultValueAssignment: assignment,
//                defaultValue: DefaultValueVisitor.getDefaultValue($0.type),
//                isClass: isClass,
//                declarationText: transformDeclarationText($0.getTrimmedDeclarationText(), isOverriding: isClass)
//            )
//        }
//    }
//
    private func getUniqueName(_ method: Method) -> String {
        return nameGenerator.getMethodName(for: method.toMethodModel().id) ?? ""
    }
//
//    private func getUniqueName(_ property: Property) -> String {
//        return nameGenerator.getMethodName(for: property.toMethodModel().id) ?? ""
//    }
//
//    private func getUniqueName(_ subscript: Subscript) -> String {
//        return nameGenerator.getMethodName(for: subscript.toMethodModel().id) ?? ""
//    }

    private func transformDeclarationText(declaration: String, isOverriding: Bool) -> String {
        var modifiers = ""
        if let scope = scope { modifiers += scope + " " }
        if isOverriding { modifiers += "override " }
        return modifiers + declaration
    }

    private func transformMethods() -> [MethodViewModel] {
        return transformMethods(classMethods, isClass: true) +
        transformMethods(protocolMethods, isClass: false)
    }

    private func transformMethods(_ methods: [Method], isClass: Bool) -> [MethodViewModel] {
        return methods.map {
            MethodViewModel(
                capitalizedUniqueName: getUniqueName($0).capitalizingFirstLetter(),
                escapingParameters: nil,
                // transformParameters($0),
                closureParameter: [],
                // $0.parametersList.compactMap(transformClosureParameters),
                resultType: nil,
                // transformReturnType($0),
                functionCall: nil,
                // MakeFunctionCallVisitor.make($0),
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

//    private func transformClosureParameters(_ parameter: Parameter) -> ClosureParameterViewModel? {
//        let visitor = FunctionParameterTransformer(parameter.internalName)
//        parameter.type.resolvedType.accept(visitor)
//        return visitor.transformed
//    }
//
//    private func transformReturnType(_ method: Method) -> ResultTypeViewModel? {
//        guard !TypeIdentifier.isEmpty(method.returnType.resolvedType) else { return nil }
//        return transformReturnType(method.returnType, genericParameters: method.genericParameters)
//    }
//
//    private func transformReturnType(_ type: ResolvedType, genericParameters: [String]) -> ResultTypeViewModel {
//        let erased = erase(type.originalType, genericParameters)
//        return ResultTypeViewModel(
//            defaultValueAssignment: getDefaultValueAssignment(type.resolvedType),
//            defaultValue: getDefaultValue(type.resolvedType),
//            unwrappedType: SurroundOptionalVisitor.surround(RemoveOptionalVisitor.removeOptional(erased), unwrapped: false).text,
//            deeplyUnwrappedType: SurroundOptionalVisitor.surround(RecursiveRemoveOptionalVisitor.removeOptional(erased), unwrapped: true).text,
//            optionalizedType: OptionalizeIUOVisitor.optionalize(erased).text,
//            castStatement: transformReturnCastStatement(originalType: type.originalType, erasedType: erased)
//        )
//    }
//
//    private func erase(_ type: Type, _ genericParameters: [String]) -> Type {
//        let copied = copy(type)
//        TypeErasingVisitor(genericParameters).visit(copied)
//        return copied
//    }
//
//    private func copy(_ type: Type) -> Type {
//        let visitor = CopyVisitor()
//        type.accept(visitor)
//        return visitor.copy
//    }
//
//    private func transformReturnCastStatement(originalType: Type, erasedType: Type) -> String {
//        guard originalType.text != erasedType.text else { return "" }
//        let optional = originalType is OptionalType ? "?" : "!"
//        let typeName = (originalType is OptionalType) ? RemoveOptionalVisitor.removeOptional(originalType).text : originalType.text
//        return " as\(optional) \(typeName)"
//    }
//
//    private func getDefaultValueAssignment(_ type: Type) -> String {
//        guard let defaultValue = DefaultValueVisitor.getDefaultValue(type), defaultValue != "nil" else { return "" }
//        return "= \(defaultValue)"
//    }
//
//    private func getDefaultValue(_ type: Type) -> String? {
//        return DefaultValueVisitor.getDefaultValue(type)
//    }
//
//    private func transformParameters(_ method: Method) -> ParametersViewModel? {
//        return transformParameters(method.parametersList, genericParameters: method.genericParameters)
//    }
//
//    private func transformParameters(_ parametersList: [Parameter], genericParameters: [String]) -> ParametersViewModel? {
//        guard let declaration = CreateInvokedParameters().transform(parametersList, genericParameters: genericParameters),
//              let assignment = SwiftStringTupleForwardCall().transform(declaration) else {
//            return nil
//        }
//        return ParametersViewModel(
//            declaration: declaration.text,
//            assignment: assignment
//        )
//    }
//
//    private func transformSubscripts() -> [SubscriptViewModel] {
//        return transformSubscripts(classSubscripts, isClass: true) +
//        transformSubscripts(protocolSubscripts, isClass: false)
//    }
//
//    private func transformSubscripts(_ subscripts: [Subscript], isClass: Bool) -> [SubscriptViewModel] {
//        return subscripts.map {
//            SubscriptViewModel(
//                name: getUniqueName($0).capitalized,
//                parameters: transformParameters($0.parameters, genericParameters: []),
//                isWritable: $0.isWritable,
//                returnType: transformReturnType($0.returnType, genericParameters: []),
//                functionCall: MakeFunctionCallVisitor.make($0),
//                isClass: isClass,
//                declarationText: transformDeclarationText($0.declarationText, isOverriding: isClass)
//            )
//        }
//    }
}

fileprivate extension Method {
    func toMethodModel() -> MethodModel {
        MethodModel(methodName: name, paramLabels: parametersList)
    }
}

fileprivate extension Property {
    func toMethodModel() -> MethodModel {
        return MethodModel(methodName: name, paramLabels: "")
    }
}

fileprivate extension Subscript {
    func toMethodModel() -> MethodModel {
        return MethodModel(methodName: "subscript", paramLabels: parameters)
    }
}
