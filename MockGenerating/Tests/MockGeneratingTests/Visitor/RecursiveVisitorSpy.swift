//
//  RecursiveVisitorSpy.swift
//  MockGenerating
//
//  Created by Andy Kayley on 14/06/2025.
//

@testable import MockGenerating

class RecursiveVisitorSpy: RecursiveVisitor {

    var visitedTypes = [TypeIdentifier]()
    func visit(typeIdentifier type: TypeIdentifier) {
        visitedTypes.append(type)
        super.visit(typeIdentifier: type)
    }

    var visitedFunctionTypes = [FunctionType]()
    override func visit(functionType type: FunctionType) {
        visitedFunctionTypes.append(type)
        super.visit(functionType: type)
    }

    var visitedOptionalTypes = [OptionalType]()
    override func visit(optionalType type: OptionalType) {
        visitedOptionalTypes.append(type)
        super.visit(optionalType: type)
    }

    var visitedTupleTypes = [TupleType]()
    override func visit(tupleType type: TupleType) {
        visitedTupleTypes.append(type)
        super.visit(tupleType: type)
    }

    var visitedArrayTypes = [ArrayType]()
    override func visit(arrayType type: ArrayType) {
        visitedArrayTypes.append(type)
        super.visit(arrayType: type)
    }

    var visitedDictionaryTypes = [DictionaryType]()
    override func visit(dictionaryType type: DictionaryType) {
        visitedDictionaryTypes.append(type)
        super.visit(dictionaryType: type)
    }

    var visitedGenericTypes = [GenericType]()
    override func visit(genericType type: GenericType) {
        visitedGenericTypes.append(type)
        super.visit(genericType: type)
    }

    var visitedMethods = [Method]()
    override func visit(method type: Method) {
        visitedMethods.append(type)
        super.visit(method: type)
    }

    var visitedProperties = [Property]()
    override func visit(property type: Property) {
        visitedProperties.append(type)
        super.visit(property: type)
    }

    var visitedInitializers = [Initializer]()
    override func visit(initializer type: Initializer) {
        visitedInitializers.append(type)
        super.visit(initializer: type)
    }

    var visitedParameters = [Parameter]()
    override func visit(parameter type: Parameter) {
        visitedParameters.append(type)
        super.visit(parameter: type)
    }
}
