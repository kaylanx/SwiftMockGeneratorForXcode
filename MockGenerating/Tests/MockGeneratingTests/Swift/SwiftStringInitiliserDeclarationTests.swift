//
//  SwiftStringInitiliserDeclarationTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

import Testing
@testable import MockGenerating

struct SwiftStringInitiliserDeclarationTests {

    @Test("Should Return Convenience Initialiser When Has Arguments")
    func shouldReturnConvenienceInitialiserWhenHasArguments() {
        let call = InitialiserCall(
            parameters: [
                Parameter.Builder(
                    externalName: "_",
                    internalName: "a"
                ).type().optional { $0.type(type: "String") }.build()
            ],
            isFailable: false
        )

        let result = SwiftStringInitialiserDeclaration().transform(call: call)
        #expect(result == "convenience init()")
    }

    @Test("Should Return Convenience Initialiser When Has Arguments And Failable")
    func shouldReturnConvenienceInitialiserWhenHasArgumentsAndFailable() {
        let call = InitialiserCall(
            parameters: [
                Parameter.Builder(
                    externalName: "_",
                    internalName: "a"
                ).type().optional { $0.type(type: "String") }.build()
            ],
            isFailable: true
        )

        let result = SwiftStringInitialiserDeclaration().transform(call: call)
        #expect(result == "convenience init()")
    }

    @Test("Should Return Overridden Initialiser When Empty Initialiser")
    func shouldReturnOverriddenInitialiserWhenEmptyInitialiser() {
        let call = InitialiserCall(
            parameters: [],
            isFailable: false
        )

        let result = SwiftStringInitialiserDeclaration().transform(call: call)
        #expect(result == "override init()")
    }

    @Test("Should Return Overridden Initialiser When Empty And Failable Initialiser")
    func shouldReturnOverriddenInitialiserWhenEmptyAndFailableInitialiser() {
        let call = InitialiserCall(
            parameters: [],
            isFailable: true
        )

        let result = SwiftStringInitialiserDeclaration().transform(call: call)
        #expect(result == "override init()")
    }
}
