//
//  DictionaryType.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

struct DictionaryType: Type {
    var keyType: `Type`
    var valueType: `Type`
    private let useVerboseSyntax: Bool

    var text: String {
        let key = keyType.text
        let value = valueType.text
        return if useVerboseSyntax {
            "Dictionary<\(key), \(value)>"
        } else {
            "[\(key): \(value)]"
        }
    }

    func accept(visitor: Visitor) {
        visitor.visit(dictionaryType: self)
    }

    func deepCopy() -> DictionaryType {
        return DictionaryType(
            keyType: CopyVisitor.copy(keyType),
            valueType: CopyVisitor.copy(valueType),
            useVerboseSyntax: useVerboseSyntax
        )
    }

    class Builder {

        private var _keyType: `Type` = TypeIdentifier.empty
        private var _valueType: `Type` = TypeIdentifier.empty
        private var _useVerboseSyntax = false

        @discardableResult
        func keyType(type: String) -> Builder {
            _keyType = TypeIdentifier(identifier: type)
            return self
        }

        @discardableResult
        func keyType() -> TypeFactory<Builder> {
            return TypeFactory(previousBuilder: self) { self._keyType = $0 }
        }

        @discardableResult
        func valueType(type: String) -> Builder {
            _valueType = TypeIdentifier(identifier: type)
            return self
        }

        @discardableResult
        func valueType() -> TypeFactory<Builder> {
            return TypeFactory(previousBuilder: self) { self._valueType = $0 }
        }

        @discardableResult
        func verbose() -> Builder {
            _useVerboseSyntax = true
            return self
        }

        func build() -> DictionaryType {
            return DictionaryType(
                keyType: _keyType,
                valueType: _valueType,
                useVerboseSyntax: _useVerboseSyntax
            )
        }
    }
}
