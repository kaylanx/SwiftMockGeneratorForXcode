//
//  NoArgumentFailableInitializerTemplate.swift
//  MockGenerating
//
//  Created by Andy Kayley on 11/06/2025.
//
@testable import MockGenerating

final class NoArgumentFailableInitializerTemplate: MockGeneratorTestTemplate {

    let expectedSwiftFileName = "NoArgumentFailableInitializer"

    func build(generator: MockTransformer) {
        generator.set(
            classInitializers:
                Initializer.Builder().failable().build()
        )
    }
}
