//
//  KeywordsStore.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//

final class KeywordsStore {

    private let keywords: Set<String> = [
        "associatedtype",
        "class",
        "deinit",
        "enum",
        "extension",
        "fileprivate",
        "func",
        "import",
        "init",
        "inout",
        "internal",
        "let",
        "open",
        "operator",
        "private",
        "protocol",
        "public",
        "static",
        "struct",
        "subscript",
        "typealias",
        "var",
        "break",
        "case",
        "continue",
        "default",
        "defer",
        "do",
        "else",
        "fallthrough",
        "for",
        "guard",
        "if",
        "in",
        "repeat",
        "return",
        "switch",
        "where",
        "while",
        "as",
        "Any",
        "catch",
        "false",
        "is",
        "nil",
        "rethrows",
        "super",
        "self",
        "Self",
        "throw",
        "throws",
        "true",
        "try",
        "async",
        "await",
        "any",
        "some"
    ]

    func isSwiftKeyword(input: String) -> Bool {
        return keywords.contains(input)
    }
}
