//
//  TypeIdentifierBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

import Testing
@testable import MockGenerating

struct TypeIdentifierBuilderTests {

    @Test("Should Build Type")
    func shouldBuildType() {
        let type = TypeIdentifier.Builder(identifier: "Type").build()
        #expect(type.text == "Type")
    }

    @Test("Should Build Nested Types")
    func shouldBuildNestedTypes() {
        let type = TypeIdentifier.Builder(identifier: "A")
            .nest(identifier: "B")
            .build()
        #expect(type.text == "A.B")
    }
}
