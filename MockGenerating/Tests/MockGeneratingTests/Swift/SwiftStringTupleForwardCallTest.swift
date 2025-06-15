//
//  SwiftStringTupleForwardCallTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//

import Testing
@testable import MockGenerating

struct SwiftStringTupleForwardCallTest  {

    @Test
    func transformsToTuple() {
        let property = TuplePropertyDeclaration(
            parameters: [
                TupleParameter(name: "param1", type: "Type1"),
                TupleParameter(name: "param2", type: "Type2")
            ]
        )
        let transformedTuple = SwiftStringTupleForwardCall().transform(property: property)
        #expect(transformedTuple == "(param1, param2)")
    }

    @Test
    func transformsVoidIntoShorthand() {
        let property = TuplePropertyDeclaration(
            parameters: [
                TupleParameter(name: "param1", type: "Type1"),
                TupleParameter(name: "param2", type: "Void")
            ]
        )
        let transformedVoidIntoShorthand = SwiftStringTupleForwardCall().transform(property: property)

        #expect(transformedVoidIntoShorthand == "(param1, ())")
    }

    @Test
    func transformsVoidShorthandIntoShorthandParameter() {
        let property = TuplePropertyDeclaration(
            parameters: [
                TupleParameter(name: "param1", type: "Type1"),
                TupleParameter(name: "param2", type: "()")
            ]
        )

        let transformedVoidShorthandIntoShorthandParameter =  SwiftStringTupleForwardCall().transform(property: property)
        #expect(transformedVoidShorthandIntoShorthandParameter == "(param1, ())")
    }

    @Test
    func transformsEmptyTuple() {
        let property = TuplePropertyDeclaration(parameters: [])
        let transformedEmptyTuple = SwiftStringTupleForwardCall().transform(property: property)
        #expect(transformedEmptyTuple == "()")
    }

    @Test
    func escapesKeywords() {
        let keywords = [
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
        keywords.forEach { keyword in
            assertEscapesKeyword(keyword: keyword)
        }
    }

    private func assertEscapesKeyword(keyword: String) {
        let property = TuplePropertyDeclaration(
            parameters: [
                TupleParameter(name: keyword, type: "Type"),
                TupleParameter(name: "param2", type: "()")
            ]
        )
        let escapedKeyword = SwiftStringTupleForwardCall().transform(property: property)
        #expect(escapedKeyword == "(`\(keyword)`, ())")
    }
}
