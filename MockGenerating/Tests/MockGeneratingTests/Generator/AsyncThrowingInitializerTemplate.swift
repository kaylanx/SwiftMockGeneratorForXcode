//
//  AsyncThrowingInitializerTemplate.swift
//  MockGenerating
//
//  Created by Andy Kayley on 11/06/2025.
//

@testable import MockGenerating

final class AsyncThrowingInitializerTemplate: MockGeneratorTestTemplate {
    let expectedSwiftFileName = "AsyncThrowingInitializer"

    func build(generator: MockTransformer) {
        generator.set(
            classInitializers:
                Initializer.Builder()
                .parameter("a") { $0.type("String") }
                .async()
                .throws()
                .build()
        )
    }
}
