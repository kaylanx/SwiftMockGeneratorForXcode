//
//  TupleTypeTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

import Testing
@testable import MockGenerating

struct TupleTypeTests {

    @Test("Should Deep Copy")
    func shouldDeepCopy() throws {
        let original = TupleType(
            tupleElements: [
                TupleType.TupleElement(
                    label: "a",
                    type: TypeIdentifier(identifier: "A")
                )
            ]
        )
        let copied = original.deepCopy()
        #expect(original.labels == copied.labels)
        #expect(original.text == copied.text)
        #expect(original.types.map(\.text) == copied.types.map(\.text))

        let firstOriginalElement = try #require(original.tupleElements.first)
        let firstCopiedElement = try #require(copied.tupleElements.first)
        #expect(firstOriginalElement !== firstCopiedElement)
        #expect(firstOriginalElement.text == "a: A")
        #expect(firstCopiedElement.text == "a: A")
    }

    @Test("Should Surround Type With Brackets")
    func shouldSurroundTypeWithBrackets() throws {
        let type = TupleType(
            tupleElements: [
                TupleType.TupleElement(
                    label: nil,
                    type: TypeIdentifier(identifier: "A")
                )
            ]
        )
        #expect(type.text == "(A)")
    }
}
