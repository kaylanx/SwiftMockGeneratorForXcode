//
//  File.swift
//  MockGenerating
//
//  Created by Andy Kayley on 05/06/2025.
//

import Testing
@testable import MockGenerating

struct OptionalTypeTests {

    @Test("Should Deep Copy")
    func shouldDeepCopy() {
        let original = OptionalType.Builder()
            .type(type: "Type")
            .build()

        let copied = original.deepCopy()
        #expect(copied.type.text == "Type")
    }
}
