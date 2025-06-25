//
//  TypeFactoryTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

import Testing
@testable import MockGenerating

struct TypeFactoryTests {

    private var typeFactory: TypeFactory<OptionalType.Builder>!

    init() {
        typeFactory = OptionalType.Builder().type()
    }

    @Test
    func testShouldBuildFunctionType() {
        let optional = typeFactory.function { _ in }.build()
        #expect(optional.text == "(() -> ())?")
    }

    @Test
    func testShouldBuildOptionalType() {
        let optional = typeFactory.optional { $0.type(type: "Type") }.build()
        #expect(optional.text == "Type??")
    }

    @Test
    func testShouldBuildArrayType() {
        let optional = typeFactory.array { $0.type(type: "Type") }.build()
        #expect(optional.text == "[Type]?")
    }

    @Test
    func testShouldBuildTupleType() {
        let optional = typeFactory.bracket().type("Type").build()
        #expect(optional.text == "(Type)?")
    }

    @Test
    func testShouldBuildDictionaryType() {
        let optional = typeFactory.dictionary { _ in }
            .build()
        #expect(optional.text == "[: ]?")
    }

    @Test
    func testShouldBuildGenericType() {
        let optional = typeFactory.generic(identifier: "Type") { _ in  }
            .build()
        #expect(optional.text == "Type<>?")
    }

    @Test
    func testShouldBuildTypeIdentifier() {
        let optional = typeFactory
            .typeIdentifier(identifier: "A") {
                $0.nest(identifier: "B")
            }
            .build()
        #expect(optional.text == "A.B?")
    }

    @Test
    func testShouldBuildTuple() {
        let optional = typeFactory.tuple { $0.element("B") }
            .build()
        #expect(optional.text == "(B)?")
    }
}
