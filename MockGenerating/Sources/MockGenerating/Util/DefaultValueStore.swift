//
//  DefaultValueStore.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

class DefaultValueStore {

    private let defaultValues: [String: String] = [
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
        "Array": "[]",
        "ArraySlice": "[]",
        "ContiguousArray": "[]",
        "Set": "[]",
        "Bool": "false",
        "Dictionary": "[:]",
        "DictionaryLiteral": "[:]",
        "UnicodeScalar": "\"!\"",
        "Character": "\"!\"",
        "StaticString": "\"\"",
        "String": "\"\""
    ]

    func getDefaultValue(for typeName: String) -> String? {
        var trimmed = typeName.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        trimmed = trimmed.replacingOccurrences(of: "<.*>", with: "", options: .regularExpression)

        if OptionalUtil.isOptional(type: trimmed) {
            return nil
        } else if isArray(trimmed) {
            return "[]"
        } else if isDictionary(trimmed) {
            return "[:]"
        }

        return defaultValues[trimmed]
    }

    private func isArray(_ typeName: String) -> Bool {
        return typeName.range(of: #"^\[[\w\d]+\]$"#, options: .regularExpression) != nil
    }

    private func isDictionary(_ typeName: String) -> Bool {
        return typeName.range(of: #"^\[[\w\d]+:[\w\d]+\]$"#, options: .regularExpression) != nil
    }
}
