//
//  TypeIdentifier.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

import Foundation

struct TypeIdentifier: `Type` {
    var identifiers: [String]

    init(identifier: String) {
        self.identifiers = [identifier]
    }

    init(identifiers: [String]) {
        self.identifiers = identifiers
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

    // Static constants and helper functions
    static let void = TypeIdentifier(identifier: "Void")
    static let emptyTuple = TupleType.Builder().build()
    static let voidTuple = TupleType.Builder().element(TypeIdentifier.void).build()
    static let empty = TypeIdentifier(identifier: "")
    static let int = TypeIdentifier(identifier: "Int")

    static func isVoid(_ type: `Type`) -> Bool {
        return [void.text, emptyTuple.text, voidTuple.text].contains(type.text)
    }

    static func isEmpty(_ type: `Type`) -> Bool {
        return empty.text == type.text
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
