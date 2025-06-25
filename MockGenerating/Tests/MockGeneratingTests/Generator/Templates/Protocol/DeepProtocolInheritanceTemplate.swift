//
//  DeepProtocolInheritanceTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 19/06/2025.
//

@testable import MockGenerating

final class DeepProtocolInheritanceTemplate: GeneratorTestTemplate {

    let expectedSwiftFileName = "DeepProtocolInheritance"

    func build(generator: Generator) {
        generator.set(
            class: MockClass.Builder()
                .protocol {
                    $0.method(name: "topMost") { _ in }
                        .protocol {
                            $0.method(name: "middle") { _ in }
                                .protocol {
                                    $0.method(name: "deepest") { _ in }
                                }
                                .protocol {
                                    $0.method(name: "deepestSibling") { _ in }
                                }
                        }
                        .protocol {
                            $0.method(name: "middleSibling1") { _ in }
                                .protocol {
                                    $0.method(name: "deepestCousin") { _ in }
                                }
                        }
                        .protocol {
                            $0.method(name: "middleSibling2") { _ in }
                        }
                }
                .protocol {
                    $0.method(name: "topSibling") { _ in }
                }
                .build()
        )
    }
}
