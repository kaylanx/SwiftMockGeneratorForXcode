//
//  IntialiserCallBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 05/06/2025.
//

import Testing
@testable import MockGenerating

struct IntializerBuilderTests {

    @Test("Should Build Empty Initializer")
    func shouldBuildEmptyInitializer() {
        let initializer = Initializer.Builder().build()
        #expect(initializer.parametersList.isEmpty)
        #expect(!initializer.isFailable)
        #expect(!initializer.async)
        #expect(!initializer.throws)
    }

    @Test("Should Build Initializer With Parameters")
    func shouldBuildInitializerWithParameters() {
        let initializer = Initializer.Builder()
            .parameter("a") { $0.type("Type") }
            .build()
        #expect(initializer.parametersList.count == 1)
        #expect(initializer.parametersList[0].text == "a: Type")
        #expect(initializer.parametersList[0].internalName == "a")
        #expect(!initializer.isFailable)
        #expect(!initializer.async)
        #expect(!initializer.throws)
    }

    @Test("Should Build Initializer With Labelled Parameters")
    func shouldBuildInitializerWithLabelledParameters() {
        let initializer = Initializer.Builder()
            .parameter("a", "b") { $0.type("Type") }
            .build()
        #expect(initializer.parametersList.count == 1)
        #expect(initializer.parametersList[0].text == "a b: Type")
        #expect(initializer.parametersList[0].externalName == "a")
        #expect(initializer.parametersList[0].internalName == "b")
        #expect(!initializer.isFailable)
        #expect(!initializer.async)
        #expect(!initializer.throws)
    }

    @Test("Should Build Failable Initializer")
    func shouldBuildFailableInitializer() {
        let initializer = Initializer.Builder().failable().build()
        #expect(initializer.isFailable)
    }

    @Test("Should Build Throwing Initializer")
    func shouldBuildThrowingInitializer() {
        let initializer = Initializer.Builder().throws().build()
        #expect(initializer.throws)
    }

    @Test("Should Build Async Initializer")
    func shouldBuildAsyncInitializer() {
        let initializer = Initializer.Builder().async().build()
        #expect(initializer.async)
    }
}
