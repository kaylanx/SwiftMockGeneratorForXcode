//
//  RecursiveVisitor.swift
//  MockGenerating
//
//  Created by Andy Kayley on 13/06/2025.
//

class RecursiveVisitor: Visitor {

    func visit(typeIdentifier type: TypeIdentifier) {
        visit(type: type)
    }

    func visit(functionType type: FunctionType) {
        type.arguments.forEach { $0.accept(visitor: self) }
        type.returnType.accept(visitor: self)
    }

    func visit(optionalType type: OptionalType) {
        type.type.accept(visitor: self)
    }

    func visit(tupleType type: TupleType) {
        type.types.forEach { $0.accept(visitor: self) }
    }

    func visit(arrayType type: ArrayType) {
        type.type.accept(visitor: self)
    }

    func visit(dictionaryType type: DictionaryType) {
        type.keyType.accept(visitor: self)
        type.valueType.accept(visitor: self)
    }

    func visit(genericType type: GenericType) {
        type.arguments.forEach { $0.accept(visitor: self) }
    }

    func visit(method type: Method) {
        type.parametersList.forEach { $0.accept(visitor: self) }
        type.returnType.resolvedType.accept(visitor: self)
    }

    func visit(property type: Property) {
        type.type.accept(visitor: self)
    }

    func visit(initializer type: Initializer) {
        type.parametersList.forEach { $0.accept(visitor: self) }
    }

    func visit(parameter type: Parameter) {
        type.type.resolvedType.accept(visitor: self)
    }
}
