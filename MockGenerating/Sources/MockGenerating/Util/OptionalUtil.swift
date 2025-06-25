//
//  OptionalUtil.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

enum OptionalUtil {

    static func removeOptional(type: String) -> String {
        if (endsWithOptional(string: type)) {
            return removeLast(string: type)
        }
        return type
    }

    static func isOptional(type: String) -> Bool {
        let trimmed = type.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.hasSuffix("?") || trimmed.hasSuffix("!") || trimmed.hasPrefix("Optional<")
    }

    static func removeOptionalRecursively(type: String) -> String {
        var modified = type
        while (endsWithOptional(string: modified)) {
            modified = removeLast(string: modified)
        }
        return modified
    }

    private static func endsWithOptional(string: String) -> Bool {
        string.hasSuffix("?") || string.hasSuffix("!")
    }

    private static func removeLast(string: String) -> String {
        String(string.dropLast())
    }
}
