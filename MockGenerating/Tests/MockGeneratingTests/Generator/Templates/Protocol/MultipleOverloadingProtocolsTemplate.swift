//
//  MultipleOverloadingProtocolsTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 18/06/2025.
//

@testable import MockGenerating

final class MultipleOverloadingProtocolsTemplate: GeneratorTestTemplate {
    let expectedSwiftFileName = "MultipleOverloadingProtocols"

    func build(generator: Generator) {
        generator.set(
            class: MockClass.Builder()
                .protocol {
                    $0.method(name: "inheriting") { _ in }
                        .method(name: "inherited") {
                            $0.parameter(name: "overloaded") { $0.type("Int") }
                        }
                }
                .protocol {
                    $0.method(name: "inherited") {
                        $0.parameter(name: "method") { $0.type("String") }
                    }
                }
                .build()
        )
    }
}
