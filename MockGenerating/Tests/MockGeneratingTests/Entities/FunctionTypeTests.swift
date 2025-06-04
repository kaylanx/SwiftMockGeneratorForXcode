//
//  FunctionTypeTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

import Testing
@testable import MockGenerating

struct FunctionTypeTests {

    @Test("Should Deep Copy")
    func testShouldDeepCopy() {
        let original = FunctionType.Builder()
            .argument(type: "FirstArgType")
            .argument(type: "SecondArgType")
            .returnType(type: "ReturnType")
            .build()
        let copied = original.deepCopy()
        #expect(copied.text == original.text)
        #expect(copied.arguments[0].text == "FirstArgType")
        #expect(copied.arguments[1].text == "SecondArgType")
        #expect(copied.returnType.text == "ReturnType")
    }
}
