//
//  OptionalTypeBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 05/06/2025.
//

import Testing
@testable import MockGenerating

struct OptionalTypeBuilderTests {

    @Test
    func testBuildOptionalType() {
        let optional = OptionalType.Builder().type(type: "Type").build()
        #expect(optional.text == "Type?")
        #expect(optional.type.text == "Type")
    }

    @Test
    func testWrapOptionalFunctionType() {
        let optional = OptionalType.Builder()
            .type()
            .function { _ in }
            .build()
        #expect(optional.text == "(() -> ())?")
    }

    @Test
    func testBuildOptionalArrayType() {
        let optional = OptionalType.Builder()
            .type()
            .array { _ in }
            .build()
        #expect(optional.text == "[]?")
    }

    @Test
    func testBuildIUOType() {
        let optional = OptionalType.Builder().type(type: "Type").unwrapped().build()
        #expect(optional.text == "Type!")
        #expect(optional.isImplicitlyUnwrapped)
    }

    @Test
    func testBuildVerboseOptionalType() {
        let optional = OptionalType.Builder().type(type: "Type").verbose().build()
        #expect(optional.text == "Optional<Type>")
    }

    @Test
    func testBuildAlreadyBuiltType() {
        let optional = OptionalType.Builder()
            .type(type: TypeIdentifiers.emptyTuple.type)
            .build()
        #expect(optional.type.text == TypeIdentifiers.emptyTuple.type.text)
    }
}
