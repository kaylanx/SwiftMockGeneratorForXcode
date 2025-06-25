//
//  MultipleProtocolTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 17/06/2025.
//

@testable import MockGenerating

final class MultipleProtocolTemplate: GeneratorTestTemplate {

    let expectedSwiftFileName = "MultipleProtocol"

    func build(generator: MockGenerating.Generator) {
        generator.set(
            class: MockClass.Builder()
                .protocol {
                    $0.initializer { $0.parameter("i1") { $0.type("Int") } }
                        .property(name: "p1") {
                            $0.type(identifier: "Int").readonly()
                        }
                        .method(name: "m1") { _ in }
                }
                .protocol {
                    $0.initializer { $0.parameter("i2") { $0.type("Int") } }
                        .property(name: "p2") {
                            $0.type(identifier: "Int").readonly()
                        }
                        .method(name: "m2") { _ in }
                }
                .protocol {
                    $0.initializer {
                        $0.parameter("i3") { $0.type("Int") } }
                        .property(name: "p3") {
                            $0.type(identifier: "Int").readonly()
                        }
                        .method(name: "m3") { _ in }
                }
                .build()
        )
    }
}
