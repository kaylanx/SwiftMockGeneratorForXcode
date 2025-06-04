//
//  OptionalizeIUOVisitorTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

import Testing
@testable import MockGenerating

struct OptionalizeIUOVisitorTests {

    @Test("Should Remove IUO And Replace With Optional")
    func shouldRemoveIUOAndReplaceWithOptional() {
        let optional = OptionalType.Builder().type(type: "A").unwrapped().build()
        let result = OptionalizeIUOVisitor.optionalize(type: optional).text
        #expect(result == "A?")
    }

    @Test("Should Remove Not Change Optional")
    func shouldRemoveNotChangeOptional() throws {
        let optional = OptionalType.Builder().type(type: "A").verbose().build()
        let result = OptionalizeIUOVisitor.optionalize(type: optional).text
        #expect(result == "Optional<A>")
    }

    @Test("Should Remove Not Change Other Type")
    func shouldRemoveNotChangeOtherType() {
        let type = TypeIdentifier.Builder("B").build()
        let result = OptionalizeIUOVisitor.optionalize(type: type).text
        #expect(result == "B")
    }
}
