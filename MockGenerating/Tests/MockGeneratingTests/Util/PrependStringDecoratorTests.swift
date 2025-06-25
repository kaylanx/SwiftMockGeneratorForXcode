//
//  PrependStringDecoratorTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 13/06/2025.
//

import Testing
@testable import MockGenerating

struct PrependStringDecoratorTests {

    @Test
    func shouldPrependPrefixToString() {
        assertPrefixCreatesStringFromString(
            prefix: "invoked",
            expected: "invokedName",
            initial: "name"
        )
    }

    @Test
    func shouldReturnEmptyString_whenInputIsEmpty() {
        assertPrefixCreatesStringFromString(
            prefix: "invoked",
            expected: "",
            initial: ""
        )
    }

    @Test
    func shouldReturnInput_whenPrefixIsEmpty() {
        assertPrefixCreatesStringFromString(
            prefix: "",
            expected: "name",
            initial: "name"
        )
    }

    @Test
    func shouldHandle1LetterName() {
        assertPrefixCreatesStringFromString(
            prefix: "invoked",
            expected: "invokedA",
            initial: "a"
        )
    }

    private func assertPrefixCreatesStringFromString(prefix: String, expected: String, initial: String) {
        let decorator = PrependStringDecorator(
            prefix: prefix
        )
        let actual = decorator.process(initial)
        #expect(actual == expected)
    }
}
