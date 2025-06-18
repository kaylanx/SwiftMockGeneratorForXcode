//
//  RecursiveRemoveOptionalVisitorTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//

import Testing
@testable import MockGenerating

struct RecursiveRemoveOptionalVisitorTests {

    @Test
    func shouldRemoveOptional() {
        let optional = OptionalType.Builder()
            .type(type: "A")
            .build()
        let transformed = RecursiveRemoveOptionalVisitor.remove(optionalType: optional)
        #expect(transformed.text == optional.type.text)
    }

    @Test
    func shouldRemoveDoubleOptional() throws {
        let optional = OptionalType.Builder()
            .type().optional { $0.type(type: "A") }
            .build()
        let transformed = RecursiveRemoveOptionalVisitor.remove(
            optionalType: optional
        )
        let innerOptional = try #require(optional.type as? OptionalType)
        #expect(innerOptional.type.text == transformed.text)
    }

    @Test
    func shouldReturnTypeWhenNotOptional() {
        let type = TypeIdentifier.Builder(identifier: "A").build()
        let transformed = RecursiveRemoveOptionalVisitor.remove(optionalType: type)
        #expect(transformed.text == type.text)
    }
}
