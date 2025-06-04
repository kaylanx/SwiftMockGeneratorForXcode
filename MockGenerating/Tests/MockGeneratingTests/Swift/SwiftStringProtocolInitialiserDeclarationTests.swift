//
//  SwiftStringProtocolInitialiserDeclarationTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

import Testing
@testable import MockGenerating

struct SwiftStringProtocolInitialiserDeclarationTestst {

    @Test("Should Create Required Empty Initialiser")
    func shouldCreateRequiredEmptyInitialiser() {
        let initializer = Initializer.Builder().build()
        let result = SwiftStringProtocolInitialiserDeclaration().transform(initializer: initializer)
        #expect(result == "required init()")
    }

    @Test("Should Copy Initialiser Signature")
    func shouldCopyInitialiserSignature() {
        let initializer = Initializer.Builder()
            .parameter("a") { $0.type().optional { $0.type(type: "String") } }
            .parameter("b") { $0.type("Int") }
            .parameter("c") { $0.type().function { _ in } }
            .build()

        let result = SwiftStringProtocolInitialiserDeclaration().transform(initializer: initializer)
        #expect(result == "required init(a: String?, b: Int, c: () -> ())")
    }

    @Test("Should Remove Failable Declaration")
    func shouldRemoveFailableDeclaration() {
        let initializer = Initializer.Builder().failable().build()
        let result = SwiftStringProtocolInitialiserDeclaration().transform(initializer: initializer)
        #expect(result == "required init()")
    }

    @Test("Should Remove Throws Clause")
    func shouldRemoveThrowsClause() {
        let initializer = Initializer.Builder().throws().build()
        let result = SwiftStringProtocolInitialiserDeclaration().transform(initializer: initializer)
        #expect(result == "required init()")
    }

    @Test("Should Remove Async Clause")
    func shouldRemoveAsyncClause() {
        let initializer = Initializer.Builder().async().build()
        let result = SwiftStringProtocolInitialiserDeclaration().transform(initializer: initializer)
        #expect(result == "required init()")
    }
}
