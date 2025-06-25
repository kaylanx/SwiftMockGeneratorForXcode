//
//  ProtocolBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

import Testing
@testable import MockGenerating

struct ProtocolBuilderTests {

    @Test("Should Build Empty Protocol")
    func shouldBuildEmptyProtocol() {
        let `protocol` = `Protocol`.Builder().build()

        #expect(`protocol`.initializers.isEmpty)
        #expect(`protocol`.properties.isEmpty)
        #expect(`protocol`.methods.isEmpty)
        #expect(`protocol`.protocols.isEmpty)
    }

    @Test("Should Build Protocols With Methods")
    func shouldBuildProtocolsWithMethods() {
        let `protocol` = `Protocol`.Builder()
            .method(name: "a") { _ in }
            .method(name: "b") { _ in }
            .build()
        
        #expect(`protocol`.methods.count == 2)
        #expect(`protocol`.methods.first?.name == "a")
        #expect(`protocol`.methods.last?.name == "b")
    }

    @Test("Should Build Protocols With Properties")
    func shouldBuildProtocolsWithProperties() {
        let `protocol` = `Protocol`.Builder()
            .property(name: "a") { _ in }
            .property(name: "b") { _ in }
            .build()
        
        #expect(`protocol`.properties.count == 2)
        #expect(`protocol`.properties.first?.name == "a")
        #expect(`protocol`.properties.last?.name == "b")
    }

    @Test("Should Build Protocol With Subscripts")
    func shouldBuildProtocolWithSubscripts() {
        let `protocol` = `Protocol`.Builder()
            .subscript(type: TypeIdentifier(identifier: "Int")) { _ in }
            .subscript(type: TypeIdentifier(identifier: "String")) { _ in }
            .build()
        
        #expect(`protocol`.subscripts.count == 2)
        #expect(`protocol`.subscripts.first?.declarationText == "subscript() -> Int")
        #expect(`protocol`.subscripts.last?.declarationText == "subscript() -> String")
    }

    @Test("Should Build Protocol With Initializers")
    func shouldBuildProtocolWithInitializers() {
        let `protocol` = `Protocol`.Builder()
            .initializer { _ in }
            .initializer { _ in }
            .build()

        #expect(`protocol`.initializers.count == 2)
    }

    @Test("Should Build Class With Inherited Protocols")
    func shouldBuildClassWithInheritedProtocols() {
        let clazz = `Protocol`.Builder()
            .protocol { _ in }
            .protocol { _ in }
            .build()
        #expect(clazz.protocols.count == 2)
    }
}
