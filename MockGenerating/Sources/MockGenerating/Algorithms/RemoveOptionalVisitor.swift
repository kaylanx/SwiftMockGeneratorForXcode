//
//  RemoveOptionalVisitor.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//

final class RemoveOptionalVisitor: Visitor {

    static func remove(optionalType type: `Type`) -> `Type` {
        let visitor = RemoveOptionalVisitor()
        type.accept(visitor: visitor)
        return visitor.transformed ?? type
    }

    private var transformed: `Type`? = nil

    func visit(optionalType type: OptionalType) {
        transformed = type.type
    }
}
