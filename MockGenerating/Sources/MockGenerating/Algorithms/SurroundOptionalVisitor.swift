//
//  SurroundOptionalVisitor.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//

final class SurroundOptionalVisitor: Visitor {

    static func surround(type: `Type`, unwrapped: Bool) -> `Type` {
        let visitor = SurroundOptionalVisitor(unwrapped: unwrapped)
        type.accept(visitor: visitor)
        return visitor.optional
    }

    private let unwrapped: Bool
    private var optional: `Type` = TypeIdentifiers.empty.type

    init(unwrapped: Bool) {
        self.unwrapped = unwrapped
    }

    func visit(type: `Type`) {
        optional = buildOptional().type(type: type).build()
    }

    func visit(functionType type: FunctionType) {
        optional = buildOptional().type().tuple { $0.element(type) }.build()
    }

    private func buildOptional() -> OptionalType.Builder {
        let builder = OptionalType.Builder()
        if unwrapped {
            builder.unwrapped()
        }
        return builder
    }
}
