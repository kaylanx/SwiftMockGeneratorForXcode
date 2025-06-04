//
//  ArrayTypeTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

import Testing
@testable import MockGenerating

struct ArrayTypeTests {

    @Test("Should Deep Copy")
    func shouldDeepCopy() {
        let original = ArrayType.Builder()
            .type(type: "Type")
            .build()
        let copied = original.deepCopy()
        #expect(original.type.text == copied.type.text)
    }
}
