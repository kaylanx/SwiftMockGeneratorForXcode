//
//  DisctionaryTypeBuilderTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

import Testing
@testable import MockGenerating

struct DictionaryTypeBuilderTests {

    @Test("Should Build Empty Dictionary")
    func shouldBuildEmptyDictionary() {
        let dictionary = DictionaryType.Builder().build()
        #expect(dictionary.text == "[: ]")
    }

    @Test("Should Build Key Type Dictionary")
    func shouldBuildKeyTypeDictionary() {
        let dictionary = DictionaryType.Builder()
            .keyType(type: "Key")
            .build()
        #expect(dictionary.keyType.text == "Key")
        #expect(dictionary.text == "[Key: ]")
    }

    @Test("Should Build Any Key Type Dictionary")
    func shouldBuildAnyKeyTypeDictionary() {
        let dictionary = DictionaryType.Builder()
            .keyType()
            .optional { $0.type(type: "Type") }
            .build()
        #expect(dictionary.keyType.text == "Type?")
        #expect(dictionary.text == "[Type?: ]")
    }

    @Test("Should Build Value Type Dictionary")
    func shouldBuildValueTypeDictionary() {
        let dictionary = DictionaryType.Builder()
            .valueType(type: "Type")
            .build()
        #expect(dictionary.valueType.text == "Type")
        #expect(dictionary.text == "[: Type]")
    }

    @Test("Should Build Any Value Type Dictionary")
    func shouldBuildAnyValueTypeDictionary() {
        let dictionary = DictionaryType.Builder()
            .valueType()
            .optional { $0.type(type: "Type") }
            .build()
        #expect(dictionary.valueType.text == "Type?")
        #expect(dictionary.text == "[: Type?]")
    }

    @Test("Should Build Dictionary")
    func shouldBuildDictionary() {
        let dictionary = DictionaryType.Builder()
            .keyType(type: "Int")
            .valueType()
            .optional { $0.type(type: "Type") }
            .build()
        #expect(dictionary.keyType.text == "Int")
        #expect(dictionary.valueType.text == "Type?")
        #expect(dictionary.text == "[Int: Type?]")
    }

    @Test("Should Build Verbose Dictionary")
    func shouldBuildVerboseDictionary() {
        let dictionary = DictionaryType.Builder()
            .keyType(type: "Int")
            .valueType()
            .optional { $0.type(type: "Type") }
            .verbose()
            .build()
        #expect(dictionary.keyType.text == "Int")
        #expect(dictionary.valueType.text == "Type?")
        #expect(dictionary.text == "Dictionary<Int, Type?>")
    }
}
