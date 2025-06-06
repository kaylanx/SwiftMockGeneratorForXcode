//
//  TupleTypeBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

import Testing
@testable import MockGenerating

struct TupleTypeBuilderTests {

    @Test("Should Build Empty Tuple")
    func shouldBuildEmptyTuple() {
        let tuple = TupleType.Builder().build()
        #expect(tuple.text == "()")
        #expect(tuple.types.isEmpty)
    }

    @Test("Should Build Simple Type Tuple")
    func shouldBuildSimpleTypeTuple() {
        let tuple = TupleType.Builder().element("Int").build()
        #expect(tuple.text == "(Int)")
        #expect(tuple.types.count == 1)
        #expect(tuple.types.first?.text == "Int")
    }

    @Test("Should Build Complex Type Tuple")
    func shouldBuildComplexTypeTuple() {
        let tuple = TupleType.Builder()
            .element().optional { $0.type(type: "A") }
            .element().array { $0.type(type: "B") }
            .build()
        #expect(tuple.text == "(A?, [B])")
        #expect(tuple.types.count == 2)
        #expect(tuple.types.first?.text == "A?")
        #expect(tuple.types.last?.text == "[B]")
    }

    @Test("Should Build Already Built Element")
    func shouldBuildAlreadyBuiltElement() {
        let tuple = TupleType.Builder()
            .element(TypeIdentifier(identifier: "A"))
            .build()
        #expect(tuple.text == "(A)")
        #expect(tuple.types.count == 1)
        #expect(tuple.types.first?.text == "A")
    }

    @Test("Should Build Tuple With Arguments")
    func shouldBuildTupleWithArguments() throws {
        let tuple = TupleType.Builder()
            .labelledElement("a", "A")
            .labelledElement("b").optional { $0.type(type: "B") }
            .build()
        #expect(tuple.text == "(a: A, b: B?)")
        #expect(tuple.types.count == 2)
        #expect(tuple.types.map(\.text).sorted() == ["A", "B?"])
        #expect(tuple.labels == ["a", "b"])
    }
}
