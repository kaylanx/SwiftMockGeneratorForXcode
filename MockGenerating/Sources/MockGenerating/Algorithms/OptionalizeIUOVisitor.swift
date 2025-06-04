//
//  OptionalizeIUOVisitor.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

final class OptionalizeIUOVisitor : Visitor {
    
    static func optionalize(type: `Type`) -> `Type` {
        let visitor = OptionalizeIUOVisitor()
        type.accept(visitor: visitor)
        return visitor.transformed ?? type
    }

    private var transformed: OptionalType?

    func visit(optionalType: OptionalType) {
        if !optionalType.isImplicitlyUnwrapped {
            return
        }
        transformed = OptionalType.Builder()
            .type(type: optionalType.type)
            .build()
    }
}
