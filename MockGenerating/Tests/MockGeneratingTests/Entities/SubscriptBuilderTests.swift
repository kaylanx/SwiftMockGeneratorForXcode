//
//  SubscriptBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

import Testing
@testable import MockGenerating

struct SubscriptBuilderTests {

    @Test("Should Build Subscript With Return Type")
    func shouldBuildSubscriptWithReturnType() {
        let `subscript` = Subscript.Builder(type: TypeIdentifiers.int.type).build()
        #expect(`subscript`.returnType.originalType.text == TypeIdentifiers.int.type.text)
        #expect(`subscript`.returnType.resolvedType.text == TypeIdentifiers.int.type.text)
        #expect(`subscript`.declarationText == "subscript() -> Int")
    }

    @Test("Should Build Subscript With Parameter")
    func shouldBuildSubscriptWithParameter() {
        let `subscript` = Subscript.Builder(type: TypeIdentifiers.int.type)
            .parameter(name: "a") { $0.type().type("String") }
            .build()
        #expect(`subscript`.parameters[0].text == "a: String")
        #expect(`subscript`.declarationText == "subscript(a: String) -> Int")
    }

    @Test("Should Build Subscript With Parameters")
    func shouldBuildSubscriptWithParameters() {
        let `subscript` = Subscript.Builder(type: TypeIdentifiers.int.type)
            .parameter(name: "a") { $0.type().type("String") }
            .parameter(externalName: "b", internalName: "b") { $0.type().type("UInt") }
            .build()
        #expect(`subscript`.parameters.count == 2)
        #expect(`subscript`.parameters.first?.text == "a: String")
        #expect(`subscript`.parameters.last?.text == "b b: UInt")
        #expect(`subscript`.declarationText == "subscript(a: String, b b: UInt) -> Int")
    }

    @Test("Should Build Subscript Writable By Default")
    func shouldBuildSubscriptWritableByDefault() {
        let `subscript` = Subscript.Builder(type: TypeIdentifiers.int.type).build()
        #expect(`subscript`.isWritable)
    }

    @Test("Should Build Subscript Read Only")
    func shouldBuildSubscriptReadOnly() {
        let `subscript` = Subscript.Builder(type: TypeIdentifiers.int.type).readonly().build()
        #expect(!`subscript`.isWritable)
    }
}
