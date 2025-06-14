//
//  TypeIdentifier.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

import Foundation

enum TypeIdentifiers {

    // Static constants and helper functions
    case void
    case emptyTuple
    case voidTuple
    case empty
    case int

    var type: `Type` {
        switch self {
        case .void: Self.voidType
        case .emptyTuple: Self.emptyTupleType
        case .voidTuple: Self.voidTupleType
        case .empty: Self.emptyType
        case .int: Self.intType
        }
    }

    static func isVoid(_ type: `Type`) -> Bool {
        let void = TypeIdentifiers.void.type
        let emptyTuple = TypeIdentifiers.emptyTuple.type
        let voidTuple = TypeIdentifiers.voidTuple.type
        return [void.text, emptyTuple.text, voidTuple.text].contains(type.text)
    }

    static func isEmpty(_ type: `Type`) -> Bool {
        return TypeIdentifiers.empty.type.text == type.text
    }

    nonisolated(unsafe) private static let voidType = TypeIdentifier(identifier: "Void")
    nonisolated(unsafe) private static let emptyTupleType = TupleType.Builder().build()
    nonisolated(unsafe) private static let voidTupleType = TupleType.Builder().element(TypeIdentifiers.void.type).build()
    nonisolated(unsafe) private static let emptyType = TypeIdentifier(identifier: "")
    nonisolated(unsafe) private static let intType = TypeIdentifier(identifier: "Int")
}

final class TypeIdentifier: `Type` {
    var identifiers: [String]

    init(identifier: String) {
        self.identifiers = [identifier]
    }

    init(identifiers: [String]) {
        self.identifiers = identifiers
    }

    func deepCopy() -> TypeIdentifier {
        TypeIdentifier(
            identifiers: self.identifiers
        )
    }

    var isEmpty: Bool {
        return text.isEmpty
    }

    var firstIdentifier: String {
        return identifiers.first ?? ""
    }

    var text: String {
        return identifiers.joined(separator: ".")
    }

    func accept(visitor: Visitor) {
        visitor.visit(typeIdentifier: self)
    }

    // Nested Builder class
    class Builder {
        private var identifiers: [String]

        init(_ identifier: String) {
            self.identifiers = [identifier]
        }

        func nest(_ identifier: String) -> Builder {
            identifiers.append(identifier)
            return self
        }

        func build() -> TypeIdentifier {
            return TypeIdentifier(identifiers: identifiers)
        }
    }
}
