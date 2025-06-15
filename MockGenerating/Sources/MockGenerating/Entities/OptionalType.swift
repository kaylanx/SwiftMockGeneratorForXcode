//
//  OptionalType.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

final class OptionalType: `Type`, Equatable {
    static func == (lhs: OptionalType, rhs: OptionalType) -> Bool {
        lhs.isImplicitlyUnwrapped == rhs.isImplicitlyUnwrapped &&
        lhs.useVerboseSyntax == rhs.useVerboseSyntax &&
        lhs.text == rhs.text
    }

    let type: `Type`
    let isImplicitlyUnwrapped: Bool
    let useVerboseSyntax: Bool

    var text: String { generateText() }

    init(type: Type, isImplicitlyUnwrapped: Bool, useVerboseSyntax: Bool) {
        self.type = type
        self.isImplicitlyUnwrapped = isImplicitlyUnwrapped
        self.useVerboseSyntax = useVerboseSyntax
    }

    private func generateText() -> String {
        let text = type.text
        return if useVerboseSyntax {
            "Optional<\(text)>"
        } else if isImplicitlyUnwrapped {
            "\(text)!"
        } else {
            "\(text)?"
        }
    }

    func accept(visitor: Visitor) {
        visitor.visit(optionalType: self)
    }

    func deepCopy() -> OptionalType {
        OptionalType(
            type: CopyVisitor.copy(type),
            isImplicitlyUnwrapped: self.isImplicitlyUnwrapped,
            useVerboseSyntax: self.useVerboseSyntax
        )
    }

    class Builder {

        private var _type: `Type` = TypeIdentifiers.empty.type
        private var implicitlyUnwrapped = false
        private var useVerboseSyntax = false

        @discardableResult
        func type(type: String) -> Builder {
            self._type = TypeIdentifier(identifier: type)
            return self
        }

        @discardableResult
        func type(type: `Type`) -> Builder {
            self._type = type
            return self
        }

        @discardableResult
        func type() -> TypeFactory<Builder> {
            return TypeFactory(previousBuilder: self) { type in
                if type is FunctionType {
                    self._type = TupleType.Builder().element(type).build()
                } else {
                    self._type = type
                }
            }
        }
        
        @discardableResult
        func unwrapped() -> Builder {
            implicitlyUnwrapped = true
            return self
        }

        @discardableResult
        func verbose() -> Builder {
            useVerboseSyntax = true
            return self
        }

        func build() -> OptionalType {
            OptionalType(
                type: _type,
                isImplicitlyUnwrapped: implicitlyUnwrapped,
                useVerboseSyntax: useVerboseSyntax
            )
        }
    }
}
