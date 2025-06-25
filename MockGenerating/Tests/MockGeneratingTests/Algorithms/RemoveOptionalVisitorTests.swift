//
//  RemoveOptionalVisitorTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//

import Testing
@testable import MockGenerating

struct RemoveOptionalVisitorTests {

    @Test
    func shouldRemoveOptional() {
        let optional = OptionalType.Builder()
            .type(type: "A")
            .build()
        let transformed = RemoveOptionalVisitor.remove(optionalType: optional)
        #expect(transformed.text == optional.type.text)
    }

    @Test
    func shouldReturnOriginalWhenNotOptional() {
        let type = TypeIdentifier.Builder(identifier: "A").build()
        let transformed = RemoveOptionalVisitor.remove(optionalType: type)
        #expect(transformed.text == type.text)
    }
}
