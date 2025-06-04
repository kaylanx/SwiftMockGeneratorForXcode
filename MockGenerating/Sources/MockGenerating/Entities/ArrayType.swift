//
//  ArrayType.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

struct ArrayType: `Type` {
    let type: `Type`
    var useVerboseSyntax: Bool

    var text: String { generateText() }

    func accept(visitor: any Visitor) {
        visitor.visit(arrayType: self)
    }

    func deepCopy() -> ArrayType {
        ArrayType(
            type: CopyVisitor.copy(type),
            useVerboseSyntax: useVerboseSyntax
        )
    }

    private func generateText() -> String {
        if useVerboseSyntax {
            return "Array<\(type.text)>"
        } else {
            return "[\(type.text)]"
        }
    }

    class Builder {
        private var _type: `Type` = TypeIdentifier.empty
        private var _useVerboseSyntax = false

        @discardableResult
        func type(type: String) -> Builder {
            self._type = TypeIdentifier(identifier: type)
            return self
        }

        @discardableResult
        func type() -> TypeFactory<Builder> {
            return TypeFactory(previousBuilder: self) { self._type = $0 }
        }

        @discardableResult
        func verbose() -> Builder {
            self._useVerboseSyntax = true
            return self
        }

        func build() -> ArrayType {
            return ArrayType(type: _type, useVerboseSyntax: _useVerboseSyntax)
        }
    }
}
