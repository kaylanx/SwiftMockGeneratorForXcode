//
//  ParameterBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 05/06/2025.
//

import Testing
@testable import MockGenerating

struct ParameterBuilderTests {

    @Test("Should Build Name")
    func buildName() {
        let param = Parameter.Builder(name: "name").build()
        #expect(param.internalName == "name")
        #expect(param.externalName == nil)
        #expect(param.type.originalType.text == ResolvedType.implicit.originalType.text)
        #expect(param.type.resolvedType.text == ResolvedType.implicit.resolvedType.text)
        #expect(param.text == "name: ")
    }

    @Test("Should Build Internal External Labels")
    func internalExternalLabels() {
        let param = Parameter.Builder(externalName: "external", internalName: "internal").build()
        #expect(param.internalName == "internal")
        #expect(param.externalName == "external")
        #expect(param.type.originalType.text == ResolvedType.implicit.originalType.text)
        #expect(param.type.resolvedType.text == ResolvedType.implicit.resolvedType.text)
        #expect(param.text == "external internal: ")
    }

    @Test("Should Build Type")
    func type() {
        let param = Parameter.Builder(name: "name").type("Type").build()
        #expect(param.internalName == "name")
        #expect(param.externalName == nil)
        #expect(param.type.originalType.text == "Type")
        #expect(param.type.resolvedType.text == "Type")
        #expect(param.text == "name: Type")
    }

    @Test("Should Build Escaping")
    func escaping() {
        let param = Parameter.Builder(name: "name").type("Type").escaping().build()
        #expect(param.internalName == "name")
        #expect(param.externalName == nil)
        #expect(param.type.originalType.text == "Type")
        #expect(param.type.resolvedType.text == "Type")
        #expect(param.isEscaping)
        #expect(param.text == "name: @escaping Type")
    }

    @Test("Should Build Inout")
    func `inout`() {
        let param = Parameter.Builder(name: "name").type("Type").inout().build()
        #expect(param.internalName == "name")
        #expect(param.externalName == nil)
        #expect(param.type.originalType.text == "Type")
        #expect(param.type.resolvedType.text == "Type")
        #expect(param.text == "name: inout Type")
    }

    @Test("Should Build Annotation")
    func annotation() {
        let param = Parameter.Builder(name: "name").type("Type").annotation("@objc").build()
        #expect(param.internalName == "name")
        #expect(param.externalName == nil)
        #expect(param.type.originalType.text == "Type")
        #expect(param.type.resolvedType.text == "Type")
        #expect(param.text == "name: @objc Type")
    }

    @Test("Should Build Resolved Type")
    func resolvedType() {
        let param = Parameter.Builder(name: "name")
            .type("Type")
            .resolvedType()
            .function { _ in }
            .build()
        #expect(param.internalName == "name")
        #expect(param.externalName == nil)
        #expect(param.type.originalType.text == "Type")
        #expect(param.type.resolvedType.text == "() -> ()")
        #expect(param.text == "name: Type")
    }
}
