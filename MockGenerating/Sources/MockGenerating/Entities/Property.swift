//
//  Untitled.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

public struct Property: Element, Equatable {
    public static func == (lhs: Property, rhs: Property) -> Bool {
        lhs.name == rhs.name &&
        lhs.type.text == rhs.type.text &&
        lhs.isWritable == rhs.isWritable &&
        lhs.declarationText == rhs.declarationText
    }

    let name: String
    let type: `Type`
    let isWritable: Bool
    let declarationText: String

    public init(
        name: String,
        type: `Type`,
        isWritable: Bool,
        declarationText: String
    ) {
        self.name = name
        self.type = type
        self.isWritable = isWritable
        self.declarationText = declarationText
    }

    public func accept(visitor: Visitor) {
        visitor.visit(property: self)
    }

    func getTrimmedDeclarationText() -> String {
        declarationText.split(separator: "{")[0].trimmingCharacters(in: .whitespacesAndNewlines)
    }

    class Builder {

        private let name: String

        init(name: String) {
            self.name = name
        }

        private var _type: `Type` = TypeIdentifiers.empty.type
        private var isWritable = true

        func readonly() -> Builder {
            isWritable = false
            return self
        }

        func type(identifier: String) -> Builder {
            _type = TypeIdentifier(identifier: identifier)
            return self
        }

        func type() -> TypeFactory<Builder> {
            return TypeFactory(previousBuilder: self) { self._type = $0 }
        }

        func build() -> Property {
            return Property(
                name: name,
                type: _type,
                isWritable: isWritable,
                declarationText: "var \(name): \(_type.text)"
            )
        }
    }
}
