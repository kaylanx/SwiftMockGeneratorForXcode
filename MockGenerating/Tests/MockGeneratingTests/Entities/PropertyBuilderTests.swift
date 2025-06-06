//
//  PropertyBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

import Testing
@testable import MockGenerating

struct PropertyBuilderTests {

    @Test("Should Build Empty Property")
    func shouldBuildEmptyProperty() {
        let property = Property.Builder(name: "a").build()
        #expect(property.name == "a")
        #expect(property.type.text == "")
        #expect(property.isWritable)
        #expect(property.declarationText == "var a: ")
    }

    @Test("Should Build Property With Simple Type")
    func shouldBuildPropertyWithSimpleType() {
        let property = Property.Builder(name: "a")
            .type(identifier: "String")
            .build()
        #expect(property.name == "a")
        #expect(property.type.text == "String")
        #expect(property.isWritable)
        #expect(property.declarationText == "var a: String")
    }

    @Test("Should Build Property With Any Type")
    func shouldBuildPropertyWithAnyType() {
        let property = Property.Builder(name: "a")
            .type()
            .optional { $0.type(type: "String") }
            .build()
        #expect(property.name == "a")
        #expect(property.type.text == "String?")
        #expect(property.isWritable)
    }

    @Test("Should Build Readonly Property")
    func shouldBuildReadonlyProperty() {
        let property = Property.Builder(name: "a")
            .readonly()
            .type(identifier: "String")
            .build()
        #expect(property.name == "a")
        #expect(!property.isWritable)
        #expect(property.declarationText == "var a: String")
    }
}
