//
//  ArgumentsInitializerTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 11/06/2025.
//

@testable import MockGenerating

final class ArgumentsInitializerTemplate: MockGeneratorTestTemplate {

    let expectedSwiftFileName = "ArgumentsInitializer"

    func build(generator: MockTransformer) {
        generator.set(
            classInitializers:
                Initializer.Builder()
                    .parameter("a") { $0.type("Int") }
                    .parameter("b") { $0.type("String") }
                    .parameter("_", "c") {
                        $0.type().optional { $0.type(type: "String") }
                    }
                    .build()
        )
    }
}
