//
//  SuperclassTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 19/06/2025.
//

@testable import MockGenerating

final class SuperclassTemplate: GeneratorTestTemplate {
    let expectedSwiftFileName = "Superclass"

    func build(generator: Generator) {
        generator.set(
            class: MockClass.Builder()
                .superclass {
                    $0.initializer {
                        $0.parameter("a1") { $0.type("Int") }
                            .parameter("a2") { $0.type("Int") }
                    }
                    .property("a") { $0.type(identifier: "Int").readonly() }
                    .method("methodA") { _ in }
                    .superclass {
                        $0.initializer { $0.parameter("b") { $0.type("Int") } }
                            .property("b") {
                                $0.type(identifier: "Int").readonly()
                            }
                            .method("methodB") { _ in }
                    }
                }
                .build()
        )
    }
}
