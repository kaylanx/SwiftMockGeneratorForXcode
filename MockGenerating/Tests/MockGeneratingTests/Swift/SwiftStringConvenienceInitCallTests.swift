//
//  SwiftStringConvenienceInitCallTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

import Testing
@testable import MockGenerating

struct SwiftStringConvenienceInitCallTests {

    @Test("Should Return Empty Call When No Parameters")
    func shouldReturnEmptyCallWhenNoParameters() {
        let call = InitialiserCall(parameters: [], isFailable: false)
        let result = SwiftStringConvenienceInitCall().transform(call: call)
        #expect(result == "self.init()")
    }

    @Test("Should Return Call With Template When Parameter Has No Default Value")
    func shouldReturnCallWithTemplateWhenParameterHasNoDefaultValue() {
        let call = InitialiserCall(
            parameters: [
                Parameter.Builder(
                    externalName: "a",
                    internalName: "a"
                ).type("Type").build()
            ],
            isFailable: false
        )

        let result = SwiftStringConvenienceInitCall().transform(call: call)
        #expect(result == "self.init(a: <\u{23}a\u{23}>)")
    }

    @Test("Should Return Call With Template When Parameters Has No Default Value")
    func shouldReturnCallWithTemplateWhenParametersHasNoDefaultValue() {
        let call = InitialiserCall(
            parameters: [
                Parameter.Builder(
                    externalName: "a",
                    internalName: "a"
                ).type("Type").build(),
                Parameter.Builder(
                    externalName: "b",
                    internalName: "b"
                ).type("Type").build()
            ],
            isFailable: false
        )

        let result = SwiftStringConvenienceInitCall().transform(call: call)
        #expect(result == "self.init(a: <\u{23}a\u{23}>, b: <\u{23}b\u{23}>)")
    }

    @Test("Should Return Call With Default Value")
    func shouldReturnCallWithDefaultValue() {
        let call = InitialiserCall(
            parameters: [
                Parameter.Builder(
                    externalName: "a",
                    internalName: "a"
                ).type("String").build(),
                Parameter.Builder(
                    externalName: "b",
                    internalName: "b"
                ).type("Int").build()
            ],
            isFailable: false
        )

        let result = SwiftStringConvenienceInitCall().transform(call: call)
        #expect(result == "self.init(a: \"\", b: 0)")
    }

    @Test("Should Return Call With Default Value For Optionals")
    func shouldReturnCallWithDefaultValueForOptionals() {
        let call = InitialiserCall(
            parameters: [
                Parameter.Builder(
                    externalName: "a",
                    internalName: "a"
                ).type().optional { $0.type(type: "String") }.build(),
                Parameter.Builder(
                    externalName: "b",
                    internalName: "b"
                ).type().optional { $0.type(type: "Int") }.build(),
                Parameter.Builder(
                    externalName: "c",
                    internalName: "c"
                ).type().optional { $0.type(type: "Object") }.build()
            ],
            isFailable: false
        )

        let result = SwiftStringConvenienceInitCall().transform(call: call)
        #expect(result == "self.init(a: nil, b: nil, c: nil)")
    }

    @Test("Should Return Call With Wild Card")
    func shouldReturnCallWithWildCard() {
        let call = InitialiserCall(
            parameters: [
                Parameter.Builder(
                    externalName: "_",
                    internalName: "a"
                ).type().optional { $0.type(type: "String") }.build(),
            ],
            isFailable: false
        )

        let result = SwiftStringConvenienceInitCall().transform(call: call)
        #expect(result == "self.init(nil)")
    }

    @Test("Should Force Unwrap Call With Optional Initializer")
    func shouldForceUnwrapCallWithOptionalInitializer() {
        let call = InitialiserCall(
            parameters: [
                Parameter.Builder(
                    externalName: "a",
                    internalName: "a"
                ).type().optional { $0.type(type: "String") }.build(),
            ],
            isFailable: true
        )

        let result = SwiftStringConvenienceInitCall().transform(call: call)
        #expect(result == "self.init(a: nil)!")
    }

    @Test("Should Force Return Overriden Init When Empty Failable Initializer")
    func shouldForceReturnOverriddenInitWhenEmptyFailableInitializer() {
        let call = InitialiserCall(
            parameters: [],
            isFailable: true
        )

        let result = SwiftStringConvenienceInitCall().transform(call: call)
        #expect(result == "super.init()!")
    }

    @Test("Should Call With Try When Initializer Throws")
    func shouldCallWithTryWhenInitializerThrows() {
        let call = InitialiserCall(
            parameters: [],
            isFailable: false,
            throws: true
        )

        let result = SwiftStringConvenienceInitCall().transform(call: call)
        #expect(result == "try! self.init()")
    }

    @Test("Should Call With Await When Initializer Async")
    func shouldCallWithAwaitWhenInitializerAsync() {
        let call = InitialiserCall(
            parameters: [],
            isFailable: false,
            async: true
        )

        let result = SwiftStringConvenienceInitCall().transform(call: call)
        #expect(result == "await self.init()")
    }

    @Test("Should Call With Try Await When Initializer Async Throws")
    func shouldCallWithTryAwaitWhenInitializerAsyncThrows() {
        let call = InitialiserCall(
            parameters: [],
            isFailable: false,
            async: true,
            throws: true
        )

        let result = SwiftStringConvenienceInitCall().transform(call: call)
        #expect(result == "try! await self.init()")
    }
}
