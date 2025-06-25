//
//  CreateConvenienceInitialiserTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

import Testing
@testable import MockGenerating

struct CreateConvenienceInitialiserTests {

    @Test("Should Return Nil For Initialiser With No Arguments")
    func shouldReturnNilForInitialiserWithNoArguments() {
        let initializer = Initializer.Builder().build()
        let convenienceInitialiser = CreateConvenienceInitialiser().transform(initializer: initializer)
        #expect(convenienceInitialiser == nil)
    }

    @Test("Should Return Nil For Throwing Initialiser With No Arguments")
    func shouldReturnNilForThrowingInitialiserWithNoArguments() {
        let initializer = Initializer.Builder()
            .throws()
            .build()
        let convenienceInitialiser = CreateConvenienceInitialiser().transform(initializer: initializer)
        #expect(convenienceInitialiser == nil)
    }

    @Test("Should Return Original Initialiser With 1 Argument")
    func shouldReturnOriginalInitialiserWith1Argument() throws {
        let initializer = Initializer.Builder()
            .parameter("a") { $0.type("String") }
            .build()
        let convenienceInitialiser = try #require(CreateConvenienceInitialiser().transform(initializer: initializer))
        #expect(convenienceInitialiser.parameters == initializer.parametersList)
    }

    @Test("Should Return Original Initialiser When Failable")
    func shouldReturnOriginalInitialiserWhenFailable() throws {
        let initializer = Initializer.Builder()
            .parameter("a") { $0.type("String") }
            .failable()
            .build()
        let convenienceInitialiser = try #require(CreateConvenienceInitialiser().transform(initializer: initializer))
        #expect(convenienceInitialiser.isFailable == true)
    }

    @Test("Should Return Throwing Initialiser When Throws")
    func shouldReturnThrowingInitialiserWhenThrows() throws {
        let initializer = Initializer.Builder()
            .parameter("a") { $0.type("String") }
            .throws()
            .build()
        let convenienceInitialiser = try #require( CreateConvenienceInitialiser().transform(initializer: initializer))
        #expect(convenienceInitialiser.throws)
    }

    @Test("Should Return Async Initialiser When Async")
    func shouldReturnAsyncInitialiserWhenAsync() throws {
        let initializer = Initializer.Builder()
            .parameter("a") { $0.type("String") }
            .async()
            .build()
        let convenienceInitialiser = try #require( CreateConvenienceInitialiser().transform(initializer: initializer))
        #expect(convenienceInitialiser.async)
    }

    @Test("Should Return Async Throwing Initialiser When Async Throws")
    func shouldReturnAsyncThrowingInitialiserWhenAsyncThrows() throws {
        let initializer = Initializer.Builder()
            .parameter("a") { $0.type("String") }
            .async()
            .throws()
            .build()
        let convenienceInitialiser = try #require( CreateConvenienceInitialiser().transform(initializer: initializer))
        #expect(convenienceInitialiser.async)
        #expect(convenienceInitialiser.throws)
    }

    @Test("Should Return Failable Initialiser When Failable And No Arguments")
    func shouldReturnFailableInitialiserWhenFailableAndNoArguments() throws {
        let initializer = Initializer.Builder()
            .failable()
            .build()
        let convenienceInitialiser = try #require( CreateConvenienceInitialiser().transform(initializer: initializer))
        #expect(convenienceInitialiser.isFailable)
        #expect(convenienceInitialiser.parameters.isEmpty)
    }
}
