//
//  ClassOverridingTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 18/06/2025.
//

@testable import MockGenerating

final class ClassOverridingTemplate: GeneratorTestTemplate {
    let expectedSwiftFileName = "ClassOverriding"

    func build(generator: Generator) {
        generator.set(
            class: MockClass.Builder()
                .superclass {
                    $0.initializer { $0.parameter("a") { $0.type("Int") } }
                        .property("a") { $0.type(identifier: "Int").readonly() }
                        .method("methodA") { _ in }
                        .superclass {
                            $0.initializer { $0.parameter("a") { $0.type("Int") } }
                                .property("a") {
                                    $0.type(identifier: "Int").readonly()
                                }
                                .method("methodA") { _ in }
                        }
                }
                .build()
        )
    }
}
