//
//  GenericTypeTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

import Testing
@testable import MockGenerating

struct GenericTypeTests {

    @Test("Should Deep Copy")
    func shouldDeepCopy() {
        let original = GenericType.Builder(identifier: "Name")
            .argument(identifier: "Arg1Type")
            .argument(identifier: "Arg2Type")
            .build()

        let copied = original.deepCopy()
        #expect(copied.arguments.count == 2)
        #expect(copied.arguments[0].text == "Arg1Type")
        #expect(copied.arguments[1].text == "Arg2Type")
    }
}
