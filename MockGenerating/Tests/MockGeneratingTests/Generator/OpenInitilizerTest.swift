//
//  OpenInitilizerTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 11/06/2025.
//

@testable import MockGenerating

final class OpenInitializerTest: MockGeneratorTestTemplate {

    let expectedSwiftFileName = "OpenInitializerTest"

    func build(generator: MockTransformer) {
        generator.set(classInitializers:
                        Initializer.Builder()
            .parameter("a") { $0.type().optional { $0.type(type: "String") } }
            .build()
        )
        generator.set(scope: "open")
    }
}
