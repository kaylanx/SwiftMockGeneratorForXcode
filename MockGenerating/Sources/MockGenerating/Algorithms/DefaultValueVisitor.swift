//
//  DefaultValueVisitor.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//

final class DefaultValueVisitor: Visitor {

    static func getDefaultValue(for element: Element) -> String? {
        let visitor = DefaultValueVisitor()
        element.accept(visitor: visitor)
        return visitor.defaultValue
    }

    var defaultValue: String? = nil

    func visit(typeIdentifier type: TypeIdentifier) {
        defaultValue = knownTypes[type.text]
    }

    func visit(functionType type: FunctionType) {
        defaultValue = buildDefaultValue(for: type)
    }

    private func buildDefaultValue(for type: FunctionType) -> String? {
        var value = [String]()
        value.append("{")
        addArgumentWildcards(value: &value, type: type)
        do {
            try addReturnTypeDefaultValue(value: &value, type: type)
        } catch {
            return nil
        }
        value.append("}")
        return value.joined(separator: " ")
    }

    private func addArgumentWildcards(value: inout [String], type: FunctionType) {
        guard !type.arguments.isEmpty else {
            return
        }
        value.append(type.arguments.map { _ in "_" }.joined(separator: ", "))
        value.append("in")
    }

    private func addReturnTypeDefaultValue(value: inout [String], type: FunctionType) throws {
        guard !TypeIdentifiers.isVoid(type.returnType) else {
            return
        }
        if let defaultValue = DefaultValueVisitor.getDefaultValue(for: type.returnType) {
            value.append("return")
            value.append(defaultValue)
        } else {
            throw DefaultValueVisitorError.defaultValueNil
        }
    }

    func visit(optionalType type: OptionalType) {
        defaultValue = "nil"
    }

    func visit(tupleType type: TupleType) {
        if type.types.isEmpty {
            defaultValue = "()"
        } else if (type.types.count == 1) {
            type.types[0].accept(visitor: self)
        } else {
            defaultValue = create(defaultTuple: type)
        }
    }

    private func create(defaultTuple type: TupleType) -> String? {
        let defaults = type.types.compactMap {
            DefaultValueVisitor.getDefaultValue(for: $0)
        }
        if (defaults.count == type.types.count) {
            return "(\(defaults.joined(separator: ", ")))"
        }
        return nil
    }

    func visit(arrayType type: ArrayType) {
        defaultValue = "[]"
    }

    func visit(dictionaryType type: DictionaryType) {
        defaultValue = "[:]"
    }

    func visit(genericType type: GenericType) {
        defaultValue = knownGenericTypes[type.identifier]
    }

    private let knownTypes: [String: String] = [
        "Double": "0",
        "Float": "0",
        "Int": "0",
        "Int16": "0",
        "Int32": "0",
        "Int64": "0",
        "Int8": "0",
        "UInt": "0",
        "UInt16": "0",
        "UInt32": "0",
        "UInt64": "0",
        "UInt8": "0",
        "Bool": "false",
        "UnicodeScalar": "\"!\"",
        "Character": "\"!\"",
        "StaticString": "\"\"",
        "String": "\"\"",
        "Void": "()"
    ]

    private let knownGenericTypes: [String: String] = [
        "Array": "[]",
        "ArraySlice": "[]",
        "ContiguousArray": "[]",
        "Set": "[]",
        "Dictionary": "[:]",
        "DictionaryLiteral": "[:]",
        "Optional": "nil"
    ]

    private enum DefaultValueVisitorError: Error {
        case defaultValueNil
    }
}
