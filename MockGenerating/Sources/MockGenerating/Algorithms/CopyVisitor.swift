//
//  CopyVisitor.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

class CopyVisitor: Visitor {
    var copy: `Type`!

    // MARK: - Static API
    static func copy(_ type: `Type`) -> `Type` {
        let visitor = CopyVisitor()
        type.accept(visitor: visitor)
        return visitor.copy
    }

    static func copy(_ types: [`Type`]) -> [`Type`] {
        return types.map { copy($0) }
    }

    // MARK: - Visitor Overrides
    func visit(typeIdentifier: TypeIdentifier) {
        copy = typeIdentifier.deepCopy()
    }

    func visit(functionType: FunctionType) {
        copy = functionType.deepCopy()
    }

    func visit(optionalType: OptionalType) {
        copy = optionalType.deepCopy()
    }

    func visit(tupleType: TupleType) {
        copy = tupleType.deepCopy()
    }

    func visit(arrayType: ArrayType) {
        copy = arrayType.deepCopy()
    }

    func visit(dictionaryType: DictionaryType) {
        copy = dictionaryType.deepCopy()
    }

    func visit(genericType: GenericType) {
        copy = genericType.deepCopy()
    }
}
