//
//  ClassBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

import Testing
@testable import MockGenerating

struct ClassBuilderTests {

    @Test("Should Build Empty Class")
    func shouldBuildEmptyClass() {
        let c = Class.Builder().build()
        #expect(c.initializers.isEmpty)
        #expect(c.properties.isEmpty)
        #expect(c.methods.isEmpty)
        #expect(c.protocols.isEmpty)
        #expect(c.inheritedClass == nil)
    }

    @Test("Should Build Class With Methods")
    func shouldBuildClassWithMethods() {
        let c = Class.Builder()
            .method("a") { _ in }
            .method("b") { _ in }
            .build()
        #expect(c.methods.count == 2)
        #expect(c.methods[0].name == "a")
        #expect(c.methods[1].name == "b")
    }

    @Test("Should Build Class with Properties")
    func shouldBuildClassWithProperties() {
        let c = Class.Builder()
            .property("a") { _ in }
            .property("b") { _ in }
            .build()
        #expect(c.properties.count == 2)
        #expect(c.properties[0].name == "a")
        #expect(c.properties[1].name == "b")
    }

    @Test("Should Build Class With Subscripts")
    func shouldBuildClassWithSubscripts() {
        let c = Class.Builder()
            .subscript(TypeIdentifier(identifier: "Int")) { _ in }
            .subscript(TypeIdentifier(identifier: "String")) { _ in }
            .build()
        #expect(c.subscripts.count == 2)
        #expect(c.subscripts[0].declarationText == "subscript() -> Int")
        #expect(c.subscripts[1].declarationText == "subscript() -> String")
    }

    @Test("Should Build Class With Initializers")
    func shouldBuildClassWithInitializers() {
        let c = Class.Builder()
            .initializer { _ in }
            .initializer { _ in }
            .build()
        #expect(c.initializers.count == 2)
    }

    @Test("Should Build Class With Inherited Class")
    func shouldBuildClassWithInheritedClass() {
        let c = Class.Builder()
            .superclass { _ in }
            .build()
        #expect(c.inheritedClass != nil)
    }
}
