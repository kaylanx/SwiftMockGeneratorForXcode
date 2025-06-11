//
//  ProtocolInitialiserTemplate.swift
//  MockGenerating
//
//  Created by Andy Kayley on 11/06/2025.
//

@testable import MockGenerating

final class ProtocolInitializerTemplate: MockGeneratorTestTemplate {

    let expectedSwiftFileName = "ProtocolInitializer"

    func build(generator: MockTransformer) {
        generator.add(initializers:
            Initializer.Builder()
                .build(),
            Initializer.Builder()
                .parameter("a") { $0.type("String") }
                .build(),
            Initializer.Builder()
                .parameter("b") { $0.type("String") }
                .failable()
                .build(),
            Initializer.Builder()
                .parameter("c") { $0.type("String") }
                .failable()
                .throws()
                .build()
        )
    }
}
