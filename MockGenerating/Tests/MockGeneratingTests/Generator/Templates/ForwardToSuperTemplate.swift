//
//  ForwardToSuperTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//

@testable import MockGenerating

final class ForwardToSuperTemplate: MockGeneratorTestTemplate {

    let expectedSwiftFileName = "ForwardToSuper"

    func build(generator: MockTransformer) {
        generator.add(
            classProperties:
                Property.Builder(name: "propA")
                    .type(identifier: "Int")
                    .build(),
                Property.Builder(name: "readonly")
                    .readonly()
                    .type(identifier: "Int")
                    .build()
        )

        generator.add(
            classMethods:
                Method.Builder(name: "method")
                    .build(),
                Method.Builder(name: "method")
                    .parameter(name: "a") { $0.type("Int") }
                    .parameter(externalName: "_", internalName: "b") { $0.type("Int") }
                    .parameter(externalName: "c", internalName: "d") { $0.type("Int") }
                    .build(),
                Method.Builder(name: "returnMethod")
                    .returnType(type: "Int")
                    .build(),
                Method.Builder(name: "forwardNoStubs")
                    .parameter(name: "a") { $0.type().function { _ in } }
                    .throws()
                    .build(),
                Method.Builder(name: "throwing")
                    .throws()
                    .returnType(type: "Int")
                    .build(),
                Method.Builder(name: "rethrowing")
                    .rethrows()
                    .returnType(type: "Int")
                    .build()
        )
        generator.add(
            properties:
                Property.Builder(name: "protocolProperty")
                    .type(identifier: "Int")
                    .build(),
                Property.Builder(name: "protocolReadonlyProperty")
                    .type(identifier: "Int")
                    .readonly()
                    .build()
        )
        generator.add(method: Method.Builder(name: "protocolMethod").build())
    }
}
