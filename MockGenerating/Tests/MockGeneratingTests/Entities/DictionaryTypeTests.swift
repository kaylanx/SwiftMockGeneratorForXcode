//
//  DictionaryTypeTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

import Testing
@testable import MockGenerating

struct DictionaryTypeTests {
    @Test("Should Deep Copy")
    func shouldDeepCopy() {
        let original = DictionaryType.Builder()
            .keyType(type: "Type")
            .valueType(type: "Type")
            .build()
        let copied = original.deepCopy()

        #expect(original.keyType.text == copied.keyType.text)
        #expect(original.valueType.text == copied.valueType.text)
    }
}
