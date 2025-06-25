//
//  MockClassBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 05/06/2025.
//

import Testing
@testable import MockGenerating

struct MockClassBuilderTests {

    @Test("Should Build Empty Class")
    func shouldBuildEmptyClass() {
        let clazz = MockClass.Builder().build()
        #expect(clazz.initializers.isEmpty)
        #expect(clazz.properties.isEmpty)
        #expect(clazz.methods.isEmpty)
        #expect(clazz.protocols.isEmpty)
        #expect(clazz.inheritedClass == nil)
        #expect(clazz.scope == nil)
    }

    @Test("Should Build Class With Inherited Class")
    func shouldBuildClassWithInheritedClass() {
        let clazz = MockClass.Builder().superclass { _ in }.build()
        #expect(clazz.inheritedClass != nil)
    }

    @Test("Should Build Class With Inherited Protocols")
    func shouldBuildClassWithInheritedProtocols() {
        let clazz = MockClass.Builder()
            .protocol { _ in }
            .protocol { _ in }
            .build()
        #expect(clazz.protocols.count == 2)
    }

    @Test("Should Set Scope")
    func shouldSetScope() {
        let clazz = MockClass.Builder()
            .scope("public")
            .build()
        #expect(clazz.scope == "public")
    }
}
