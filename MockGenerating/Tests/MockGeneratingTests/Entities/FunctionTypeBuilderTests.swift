//
//  FunctionTypeBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

import Testing
@testable import MockGenerating

struct FunctionTypeBuilderTests {

    @Test("Should Build Empty Closure")
    func shouldBuildEmptyClosure() {
        let type = FunctionType.Builder().build()
        #expect(type.arguments.isEmpty)
        #expect(!type.throws)
        #expect(!type.async)
        #expect(type.returnType.text == TypeIdentifier.emptyTuple.text)
        #expect(type.text == "() -> ()")
    }

    @Test("Should Build Throwing Closure")
    func shouldBuildThrowingClosure() {
        let type = FunctionType.Builder()
            .throws()
            .build()
        #expect(type.throws)
        #expect(type.text == "() throws -> ()")
    }

    @Test("Should Build Async Closure")
    func shouldBuildAsyncClosure() {
        let type = FunctionType.Builder()
            .async()
            .build()
        #expect(type.async)
        #expect(type.text == "() async -> ()")
    }

    @Test("Should Build Async Throwing Closure")
    func shouldBuildAsyncThrowingClosure() {
        let type = FunctionType.Builder()
            .async()
            .throws()
            .build()
        #expect(type.async)
        #expect(type.text == "() async throws -> ()")
    }

    @Test("Should Build Argument")
    func shouldBuildArgument() {
        let type = FunctionType.Builder().argument(type: "Type").build()
        #expect(type.arguments.count == 1)
        #expect(type.arguments[0].text == "Type")
    }

    @Test("Should Build Non Optional and Optional Arguments")
    func shouldBuildNonOptionalAndOptionalArguments() {
        let type = FunctionType.Builder()
            .argument(type: "Type")
            .argument().optional { $0.type(type: "Type2") }
            .build()
        #expect(type.arguments.count == 2)
        #expect(type.arguments[0].text == "Type")
        #expect(type.arguments[1].text == "Type2?")
        #expect(type.text == "(Type, Type2?) -> ()")
    }

    @Test("Should Build Closure With Return Type")
    func shouldBuildClosureWithReturnType() {
        let type = FunctionType.Builder()
            .returnType(type: "Type")
            .build()
        #expect(type.text == "() -> Type")
        #expect(type.returnType.text == "Type")
    }

    @Test("Should Build Optional Argument")
    func shouldBuildOptionalArgument() {
        let type = FunctionType.Builder()
            .argument().optional { $0.type(type: "Type") }
            .build()
        #expect(type.text == "(Type?) -> ()")
        #expect(type.arguments[0].text == "Type?")
        #expect(type.returnType.text == "()")
    }

    @Test("Should Build Array Argument")
    func shouldBuildArrayArgument() {
        let type = FunctionType.Builder()
            .argument().array { _ in }
            .build()
        #expect(type.text == "([]) -> ()")
        #expect(type.arguments[0].text == "[]")
        #expect(type.returnType.text == "()")
    }
}
