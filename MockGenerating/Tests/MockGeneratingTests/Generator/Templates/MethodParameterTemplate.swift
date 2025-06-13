//
//  MethodParameterTemplate.swift
//  MockGenerating
//
//  Created by Andy Kayley on 13/06/2025.
//

@testable import MockGenerating

final class MethodParameterTemplate: MockGeneratorTestTemplate {

    let expectedSwiftFileName = "MethodParameter"

    func build(generator: MockTransformer) {
        generator.add(
            methods: 
                Method.Builder(name: "oneParam")
                    .parameter(name: "param0") { $0.type("Int") }
                    .build(),
                Method.Builder(name: "twoParam")
                    .parameter(name: "param0") { $0.type("Int") }
                    .parameter(name: "param1") { $0.type("String") }
                    .build(),
                Method.Builder(name: "optionalParam")
                    .parameter(name: "param0") { $0.type().optional { $0.type(type: "Int") } }
                    .build(),
                Method.Builder(name: "iuoParam")
                    .parameter(name: "param0") { $0.type().optional { $0.unwrapped().type(type: "Int") } }
                    .build(),
                Method.Builder(name: "noLabelParam")
                    .parameter(externalName: "_", internalName: "name0") { $0.type().optional { $0.unwrapped().type(type: "Int") } }
                    .build(),
                Method.Builder(name: "nameAndLabelParam")
                    .parameter(externalName: "label0", internalName: "name0") { $0.type().optional { $0.unwrapped().type(type: "Int") } }
                    .build(),
                Method.Builder(name: "closureParam")
                    .parameter(name: "closure") { $0.type().function { _ in } }
                    .build()
        )
    }
}
