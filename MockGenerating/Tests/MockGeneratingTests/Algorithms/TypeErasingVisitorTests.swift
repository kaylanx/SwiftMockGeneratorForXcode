//
//  TypeErasingVisitorTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 19/06/2025.
//

import Testing
@testable import MockGenerating

struct TypeErasingVisitorTests {

    @Test
    func shouldEraseNestedType() {
        let method = buildMethod()
            .parameter(name: "t") {
                $0.type()
                    .typeIdentifier(identifier: "T") {
                        $0.nest(identifier: "Nested")
                    }
            }
            .build()
        let actual = erase(
            type: method.parametersList[0].type.originalType
        ).text
        #expect(actual == "Any")
    }

    @Test
    func shouldEraseType() {
        let method = buildMethod()
            .parameter(name: "t") { $0.type("T") }
            .build()
        let actual = erase(
            type: method.parametersList[0].type.originalType
        ).text
        #expect(actual == "Any")
    }

    @Test
    func shouldEraseOptional() {
        let method = buildMethod()
            .parameter(name: "t") { $0.type().optional { $0.type(type: "T") } }
            .build()
        let actual = erase(
            type: method.parametersList[0].type.originalType
        ).text
        #expect(actual == "Any?")
    }

    @Test
    func shouldEraseFunction() {
        let method = buildMethod()
            .parameter(name: "t") {
                $0.type().function { `func` in
                    `func`.argument(type: "T")
                        .returnType(type: "T")
                }
            }
            .build()
        let actual = erase(type: method.parametersList[0].type.originalType).text
        #expect(actual == "(Any) -> Any")
    }

    @Test
    func shouldEraseTypesWithMultipleGenerics() {
        let method = buildMethod()
            .parameter(name: "t") {
                $0.type().function { `func` in
                    `func`.argument(type: "T")
                        .returnType(type: "U")
                }
            }
            .build()
        let actual = erase(type: method.parametersList[0].type.originalType).text
        #expect(actual == "(Any) -> Any")
    }

    @Test
    func shouldEraseTuple() {
        let method = buildMethod()
            .parameter(name: "t") {
                $0.type().tuple { tuple in
                    tuple.element("T")
                        .element("Int")
                }
            }
            .build()
        let actual = erase(type: method.parametersList[0].type.originalType).text
        #expect(actual == "(Any, Int)")
    }

    @Test
    func shouldEraseDictionaryKeyToAnyHashable() {
        let method = buildMethod()
            .parameter(name: "t") {
                $0.type().dictionary { dict in
                    dict.keyType(type: "T")
                        .valueType(type: "U")
                }
            }
            .build()
        let actual = erase(type: method.parametersList[0].type.originalType).text
        #expect(actual == "[AnyHashable: Any]")
    }

    @Test
    func shouldNotEraseDictionaryKeyWhenNotGeneric() {
        let method = buildMethod()
            .parameter(name: "t") {
                $0.type().dictionary { dict in
                    dict.keyType(type: "Key")
                        .valueType(type: "Value")
                }
            }
            .build()
        let actual = erase(type: method.parametersList[0].type.originalType).text
        #expect(actual == "[Key: Value]")
    }

    private func buildMethod() -> Method.Builder {
        return Method.Builder(name: "method")
    }

    private func erase(type: `Type`) -> `Type` {
        TypeErasingVisitor.erase(type: type, genericIdentifiers: ["T", "U"])
        return type
    }
}
