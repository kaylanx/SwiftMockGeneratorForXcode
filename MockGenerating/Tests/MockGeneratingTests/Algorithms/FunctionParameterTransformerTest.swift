//
//  FunctionParameterTransformerTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//

import Testing
@testable import MockGenerating

struct FunctionParameterTransformerTest {

    @Test
    func shouldCapitalizeName() throws {
        let capitalizedName = try transformEmptyFunction().capitalizedName
        #expect(capitalizedName == "Name")
    }

    @Test
    func shouldPreserveName() throws {
        let name = try transformEmptyFunction().name
        #expect(name == "name")
    }

    @Test
    func shouldBeFalseWhenNoArguments() throws {
        let hasArguments = try transformEmptyFunction().hasArguments
        #expect(hasArguments == false)
    }

    @Test
    func shouldBeTrueNoArguments() throws {
        let hasArguments = try transformSimpleFunction().hasArguments
        #expect(hasArguments == true)
    }

    @Test
    func shouldTransformEmptyFunctionToEmptyTuple() throws {
        let argumentsTupleRepresentation = try transformEmptyFunction().argumentsTupleRepresentation
        #expect(argumentsTupleRepresentation == "()")
    }

    @Test
    func shouldTransformAppendVoidTo1ArgumentFunctionTuple() throws {
        let argumentsTupleRepresentation = try transformSimpleFunction().argumentsTupleRepresentation
        #expect(argumentsTupleRepresentation == "(A, Void)")
    }

    @Test
    func shouldTransformCreateTupleFrom2ArgumentFunctionTuple() throws {
        let argumentsTupleRepresentation = try transform2ArgumentFunction().argumentsTupleRepresentation
        #expect(argumentsTupleRepresentation == "(A, B)")
    }

    @Test
    func shouldTransformEmptyTupleIntoClosureCall() throws {
        let closureCall = try transformEmptyFunction().implicitClosureCall
        #expect(closureCall == "name()")
    }

    @Test
    func shouldTransformSimpleTupleIntoClosureCall() throws {
        let closureCall = try transformSimpleFunction().implicitClosureCall
        #expect(closureCall == "name(result.0)")
    }

    @Test
    func shouldTransform2ArgumentTupleIntoClosureCall() throws {
        let closureCall = try transform2ArgumentFunction().implicitClosureCall
        #expect(closureCall == "name(result.0, result.1)")
    }

    @Test
    func shouldSuppressWarningFromClosureCall() throws {
        let closureCall = try transformReturnFunction().implicitClosureCall
        #expect(closureCall == "_ = name()")
    }

    @Test
    func shouldTryToCallThrowingClosure() throws {
        let closureCall = try transformThrowingFunction().implicitClosureCall
        #expect(closureCall == "try? name()")
    }

    @Test
    func shouldCallAsyncClosure() throws {
        let closureCall = try transformAsyncFunction().implicitClosureCall
        #expect(closureCall == "await name()")
    }

    @Test
    func shouldTryToCallAsyncThrowingClosure() throws {
        let closureCall = try transformAsyncThrowingFunction().implicitClosureCall
        #expect(closureCall == "try? await name()")
    }

    @Test
    func shouldTryToCallOptionalClosure() throws {
        let closureCall = try transformOptionalFunction().implicitClosureCall
        #expect(closureCall == "name?()")
    }

    private func transformOptionalFunction() throws -> ClosureParameterViewModel {
        let function = OptionalType.Builder()
            .type().function {_ in }
            .build()
        return try #require(transform(type: function))
    }

    private func transformReturnFunction() throws -> ClosureParameterViewModel {
        let function = FunctionType.Builder()
            .returnType(type: "T")
            .build()
        return try #require(transform(type: function))
    }

    private func transformThrowingFunction() throws -> ClosureParameterViewModel {
        let function = FunctionType.Builder()
            .throws()
            .build()
        return try #require(transform(type: function))
    }

    private func transformAsyncFunction() throws -> ClosureParameterViewModel {
        let function = FunctionType.Builder()
            .async()
            .build()
        return try #require(transform(type: function))
    }

    private func transformAsyncThrowingFunction() throws -> ClosureParameterViewModel {
        let function = FunctionType.Builder()
            .async()
            .throws()
            .build()
        return try #require(transform(type: function))
    }

    private func transformSimpleFunction() throws -> ClosureParameterViewModel {
        let function = FunctionType.Builder()
            .argument(type: "A")
            .build()
        return try #require(transform(type: function))
    }

    private func transform2ArgumentFunction() throws -> ClosureParameterViewModel {
        let function = FunctionType.Builder()
            .argument(type: "A")
            .argument(type: "B")
            .build()
        return try #require(transform(type: function))
    }

    private func transformEmptyFunction() throws -> ClosureParameterViewModel {
        let function = FunctionType.Builder().build()
        return try #require(transform(type: function))
    }

    private func transform(type: Type) -> ClosureParameterViewModel? {
        let visitor = FunctionParameterTransformer(name: "name")
        type.accept(visitor: visitor)
        return visitor.transformed
    }
}
