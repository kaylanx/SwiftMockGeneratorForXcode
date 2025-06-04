//
//  ArrayTypeBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

import Testing
@testable import MockGenerating

struct ArrayTypeBuilderTests {

    @Test("Should Build Empty Array")
    func shouldBuildEmptyArray() {
        let array = ArrayType.Builder().build()
        #expect(array.text == "[]")
        #expect(array.type.text == TypeIdentifier.empty.text)
    }

    @Test("Should Build Array With Type")
    func shouldBuildArrayWithType() {
        let array = ArrayType.Builder().type(type: "Type").build()
        #expect(array.text == "[Type]")
        #expect(array.type.text == "Type")
    }

    @Test("Should Build Array With Any Type")
    func shouldBuildArrayWithAnyType() {
        let array = ArrayType.Builder().type().array { $0.type(type: "Type") }.build()
        #expect(array.text == "[[Type]]")
        #expect(array.type.text == "[Type]")
    }

    @Test("Should Build Verbose Array")
    func shouldBuildVerboseArray() {
        let array = ArrayType.Builder().verbose().type(type: "Type").build()
        #expect(array.text == "Array<Type>")
        #expect(array.type.text == "Type")
    }
}
