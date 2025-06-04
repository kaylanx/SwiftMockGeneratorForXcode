//
//  GenericTypeBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

import Testing
@testable import MockGenerating

struct GenericTypeBuilderTests {

    @Test("Should Build Empty Generic Type")
    func shouldBuildEmptyGenericType() {
        let type = GenericType.Builder(identifier: "Type").build()
        #expect(type.text == "Type<>")
    }

    @Test("Should Build Generic Type With Argument")
    func shouldBuildGenericTypeWithArgument() {
        let type = GenericType.Builder(identifier: "Type")
            .argument(identifier: "T")
            .build()
        #expect(type.arguments[0].text == "T")
        #expect(type.text == "Type<T>")
    }

    @Test("Should Build Generic Type With Arguments")
    static func shouldBuildGenericTypeWithArguments() {
        let type = GenericType.Builder(identifier: "Type")
            .argument().optional { $0.type(type: "T") }
            .argument().function { _ in }
            .build()
        #expect(type.arguments.count == 2)
        #expect(type.arguments[0].text == "T?")
        #expect(type.arguments[1].text == "() -> ()")
        #expect(type.text == "Type<T?, () -> ()>")
    }
}
