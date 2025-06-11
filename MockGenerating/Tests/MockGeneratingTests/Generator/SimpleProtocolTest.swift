//
//  SimpleProtocolTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 11/06/2025.
//
@testable import MockGenerating

final class SimpleProtocolTest: MockGeneratorTestTemplate {

    let expectedSwiftFileName = "SimpleProtocolTest"

    func build(generator: MockTransformer) {
        generator.add(
            method: Method.Builder(name: "simpleMethod").build()
        )
    }
}
