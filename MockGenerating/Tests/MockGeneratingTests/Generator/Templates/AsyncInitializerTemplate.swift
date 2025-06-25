//
//  AsyncInitializerTemplate.swift
//  MockGenerating
//
//  Created by Andy Kayley on 11/06/2025.
//

@testable import MockGenerating

final class AsyncInitializerTemplate: MockGeneratorTestTemplate {
    let expectedSwiftFileName = "AsyncInitializer"

    func build(generator: MockTransformer) {
        generator.set(
            classInitializers:
                Initializer.Builder()
                    .parameter("a") { $0.type("String") }
                    .async()
                    .build()
        )
    }
}
