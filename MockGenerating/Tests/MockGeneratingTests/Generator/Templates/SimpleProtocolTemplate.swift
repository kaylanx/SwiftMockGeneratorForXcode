//
//  SimpleProtocolTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 11/06/2025.
//
@testable import MockGenerating

final class SimpleProtocolTemplate: MockGeneratorTestTemplate {

    let expectedSwiftFileName = "SimpleProtocol"

    func build(generator: MockTransformer) {
        generator.add(
            method:
                Method.Builder(
                    name: "simpleMethod"
                ).build()
        )
    }
}
