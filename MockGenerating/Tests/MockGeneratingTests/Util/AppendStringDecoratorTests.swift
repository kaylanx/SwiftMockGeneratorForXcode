//
//  AppendStringDecoratorTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 13/06/2025.
//

import Testing
@testable import MockGenerating

struct AppendStringDecoratorTests {
    @Test
    func shouldAppendSuffixToString() {
        assertSuffixCreatesStringFromString(
            suffix: "WasCalled",
            expected: "nameWasCalled",
            initial: "name"
        )
    }

    @Test
    func shouldReturnEmptyString_whenInputIsEmpty() {
        assertSuffixCreatesStringFromString(
            suffix: "invoked",
            expected: "",
            initial: ""
        )
    }

    @Test
    func shouldReturnInput_whenSuffixIsEmpty() {
        assertSuffixCreatesStringFromString(
            suffix: "",
            expected: "name",
            initial: "name"
        )
    }

    @Test
    func shouldHandle1LetterName() {
        assertSuffixCreatesStringFromString(
            suffix: "WasCalled",
            expected: "aWasCalled",
            initial: "a"
        )
    }

    private func assertSuffixCreatesStringFromString(
        suffix: String,
        expected: String,
        initial: String
    ) {
        let decorator = AppendStringDecorator(
            nextDecorator: nil,
            suffix: suffix
        )
        let actual = decorator.decorate(initial)
        #expect(actual == expected)
    }
}
