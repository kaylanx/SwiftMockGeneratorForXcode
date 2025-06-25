//
//  ArgumentsInitialiserTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 19/06/2025.
//

@testable import MockGenerating

final class AugmentedClassSubscriptTemplate: GeneratorTestTemplate {
    
    let expectedSwiftFileName = "AugmentedClassSubscript"

    func build(generator: Generator) {
        generator.set(
            class: MockClass.Builder()
                .superclass {
                    $0.subscript(TypeIdentifier(identifier: "Int")) { _ in }
                        .subscript(TypeIdentifier(identifier: "Int")) {
                            $0.parameter(name: "b") {
                                $0.type("Int")
                            }
                        }
                        .superclass {
                            $0.subscript(TypeIdentifier(identifier: "Int")) {
                                $0.readonly()
                                    .parameter(name: "b") {
                                        $0.type("Int")
                                    }
                            }
                        }
                }
                .protocol {
                    $0.subscript(type: TypeIdentifier(identifier: "Int")) {
                        $0.readonly()
                    }
                }
                .build()
        )
    }
}
