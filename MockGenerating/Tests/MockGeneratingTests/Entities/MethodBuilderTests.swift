//
//  MethodBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 05/06/2025.
//

import Testing
@testable import MockGenerating

struct MethodBuilderTests {
    @Test("Should Build Default Method")
    func shouldBuildDefaultMethod() {
        let method = Method.Builder(name: "name").build()
        #expect(method.name == "name")
        #expect(method.returnType.originalType.text == ResolvedTypes.implicit.type.originalType.text)
        #expect(method.returnType.resolvedType.text == ResolvedTypes.implicit.type.resolvedType.text)
        #expect(method.parametersList.isEmpty)
        #expect(!method.throws)
        #expect(!method.async)
        #expect("func name()" == method.declarationText)
    }

    @Test("Should Build Return Type")
    func shouldBuildReturnType() {
        let method = Method.Builder(name: "name").returnType(type: "Type").build()
        #expect(method.returnType.originalType.text == "Type")
        #expect(method.returnType.resolvedType.text == "Type")
        #expect(method.declarationText == "func name() -> Type")
    }

    @Test("Should Build Throwing Method")
    func shouldBuildThrowingMethod() {
        let method = Method.Builder(name: "name").throws().build()
        #expect(method.throws)
        #expect(method.declarationText == "func name() throws")
    }

    @Test("Should Build Returning Throwing Method")
    func shouldBuildReturningThrowingMethod() {
        let method = Method.Builder(name: "name").throws().returnType(type: "Type").build()
        #expect(method.declarationText == "func name() throws -> Type")
    }

    @Test("Should Build Async Throwing Method")
    func shouldBuildAsyncThrowingMethod() {
        let method = Method.Builder(name: "name").throws().async().build()
        #expect(method.declarationText == "func name() async throws")
    }

    @Test("Should Build Async Returning Throwing Method")
    func shouldBuildAsyncReturningThrowingMethod() {
        let method = Method.Builder(name: "name").throws().async().returnType(type: "Type").build()
        #expect(method.declarationText == "func name() async throws -> Type")
    }

    @Test("Should Build Rethrowing Method")
    func shouldBuildRethrowingMethod() {
        let method = Method.Builder(name: "name").rethrows().build()
        #expect(method.rethrows)
        #expect(method.declarationText == "func name() rethrows")
    }

    @Test("Should Build Returning Rethrowing Method")
    func shouldBuildReturningRethrowingMethod() {
        let method = Method.Builder(name: "name").rethrows().returnType(type: "Type").build()
        #expect(method.declarationText == "func name() rethrows -> Type")
    }

    @Test("Should Build Async Rethrowing Method")
    func shouldBuildAsyncRethrowingMethod() {
        let method = Method.Builder(name: "name").rethrows().async().build()
        #expect(method.declarationText == "func name() async rethrows")
    }

    @Test("Should Build Async Returning Rethrowing Method")
    func shouldBuildAsyncReturningRethrowingMethod() {
        let method = Method.Builder(name: "name").rethrows().async().returnType(type: "Type").build()
        #expect(method.declarationText == "func name() async rethrows -> Type")
    }

    @Test("Should Build Parameter")
    func shouldBuildParameter() throws {
        let method = Method.Builder(name: "a").parameter(name: "name") { $0.type("Type") }.build()
        let firstParameter = try #require(method.parametersList.first)
        #expect(firstParameter.internalName == "name")
        #expect(firstParameter.type.originalType.text == "Type")
        #expect(method.declarationText == "func a(name: Type)")
    }

    @Test("Should Build Parameters")
    func shouldBuildParameters() throws {
        let method = Method.Builder(name: "a")
            .parameter(name: "name") { $0.type("Type") }
            .parameter(name: "name2") { $0.type("Type2") }
            .build()
        let firstParameter = try #require(method.parametersList.first)
        let secondParameter = try #require(method.parametersList.last)

        #expect(firstParameter.internalName == "name")
        #expect(firstParameter.type.originalType.text == "Type")
        #expect(secondParameter.internalName == "name2")
        #expect(secondParameter.type.originalType.text == "Type2")
        #expect(method.declarationText == "func a(name: Type, name2: Type2)")
    }

    @Test("Should Build Generic Parameters")
    func shouldBuildGenericParameters() throws {
        let method = Method.Builder(name: "a")
            .genericParameter(identifier: "T")
            .build()
        let firstGenericParameter = try #require(method.genericParameters.first)
        #expect(firstGenericParameter == "T")
        #expect(method.declarationText == "func a<T>()")
    }
}
