//
//  Visitor.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

public protocol Visitor {
    func visit(type: `Type`)
    func visit(initializer: Initializer)
    func visit(parameter: Parameter)
    func visit(typeIdentifier: TypeIdentifier)
    func visit(tupleType: TupleType)
    func visit(functionType: FunctionType)
    func visit(property: Property)
    func visit(method: Method)
    func visit(subscript: Subscript)
    func visit(optionalType: OptionalType)
    func visit(arrayType: ArrayType)
    func visit(dictionaryType: DictionaryType)
    func visit(genericType: GenericType)
}

extension Visitor {

    func visit(type: `Type`) { }

    func visit(typeIdentifier type: TypeIdentifier) {
        visit(type: type)
    }

    func visit(functionType type: FunctionType) {
        visit(type: type)
    }

    func visit(optionalType type: OptionalType) {
        visit(type: type)
    }

    func visit(tupleType type: TupleType) {
        visit(type: type)
    }

    func visit(arrayType type: ArrayType) {
        visit(type: type)
    }

    func visit(dictionaryType type: DictionaryType) {
        visit(type: type)
    }

    func visit(genericType type: GenericType) {
        visit(type: type)
    }

    func visit(method: Method) { }

    func visit(property: Property) { }

    func visit(initializer: Initializer) { }

    func visit(parameter: Parameter) { }

    func visit(subscript: Subscript) { }
}
