//
//  SimplestInitializerTemplate.swift
//  MockGenerating
//
//  Created by Andy Kayley on 11/06/2025.
//
@testable import MockGenerating

final class SimplestClassInitializerTemplate: MockGeneratorTestTemplate {

    let expectedSwiftFileName = "SimplestClassInitializer"

    func build(generator: MockTransformer) {
        generator.set(
            classInitializers:
                Initializer.Builder()
                    .parameter("a") { $0.type("Int") }
                    .parameter("b") { $0.type("String") }
                    .build(),
                Initializer.Builder()
                    .parameter("a") { $0.type("Int") }
                    .parameter("b") { $0.type("String") }
                    .parameter("c") { $0.type("UInt") }
                    .build(),
                Initializer.Builder()
                    .parameter("a") { $0.type("String") }
                    .build()
        )
    }
}
