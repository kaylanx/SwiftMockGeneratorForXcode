//
//  DefaultValueVisitorTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//

import Testing
@testable import MockGenerating

struct DefaultValueVisitorTest {

    @Test
    func shouldReturnEmptyStringWhenUnknownType() {
        #expect(getDefaultValue(for: "Unknown") == nil)
    }

    @Test
    func whenKnownType() {
        #expect(getDefaultValue(for: "Double") == "0")
        #expect(getDefaultValue(for: "Float") == "0")
        #expect(getDefaultValue(for: "Int") == "0")
        #expect(getDefaultValue(for: "Int16") == "0")
        #expect(getDefaultValue(for: "Int32") == "0")
        #expect(getDefaultValue(for: "Int64") == "0")
        #expect(getDefaultValue(for: "Int8") == "0")
        #expect(getDefaultValue(for: "UInt") == "0")
        #expect(getDefaultValue(for: "UInt16") == "0")
        #expect(getDefaultValue(for: "UInt32") == "0")
        #expect(getDefaultValue(for: "UInt64") == "0")
        #expect(getDefaultValue(for: "UInt8") == "0")
        #expect(getDefaultValue(for: "Bool") == "false")
        #expect(getDefaultValue(for: "UnicodeScalar") == "\"!\"")
        #expect(getDefaultValue(for: "Character") == "\"!\"")
        #expect(getDefaultValue(for: "StaticString") == "\"\"")
        #expect(getDefaultValue(for: "String") == "\"\"")
    }

    @Test
    func whenKnownGenericType() {
        #expect(getDefaultValueForGeneric(for: "Array") == "[]")
        #expect(getDefaultValueForGeneric(for: "ArraySlice") == "[]")
        #expect(getDefaultValueForGeneric(for: "ContiguousArray") == "[]")
        #expect(getDefaultValueForGeneric(for: "Set") == "[]")
        #expect(getDefaultValueForGeneric(for: "Dictionary") == "[:]")
        #expect(getDefaultValueForGeneric(for: "DictionaryLiteral") == "[:]")
        #expect(getDefaultValueForGeneric(for: "Optional") == "nil")
    }

    @Test
    func whenSimpleFunction() {
        let function = FunctionType.Builder().build()
        #expect(getDefaultValue(for: function) == "{ }")
    }

    @Test
    func whenFunctionWithArguments() {
        let function = FunctionType.Builder()
            .argument(type: "A")
            .argument(type: "B")
            .build()
        #expect(getDefaultValue(for: function) == "{ _, _ in }")
    }

    @Test
    func whenFunctionWithKnownReturnType() {
        let function = FunctionType.Builder()
            .returnType(type: "Int")
            .build()
        #expect(getDefaultValue(for: function) == "{ return 0 }")
    }

    @Test
    func whenFunctionHasUnknownReturnValueShouldNotHaveDefaultValue() {
        let function = FunctionType.Builder()
            .returnType(type: "Unknown")
            .build()
        #expect(getDefaultValue(for: function) == nil)
    }

    @Test
    func whenOptional() {
        let optional = OptionalType.Builder()
            .type(type: "Any")
            .build()
        #expect(getDefaultValue(for: optional) == "nil")
    }

    @Test
    func whenKnownTypeSurroundedInBracket() {
        let type = TupleType.Builder().element("Int").build()
        #expect(getDefaultValue(for: type) == "0")
    }

    @Test
    func whenUnknownTypeSurroundedInBracket() {
        let type = TupleType.Builder().element("Unknown").build()
        #expect(getDefaultValue(for: type) == nil)
    }

    @Test
    func whenEmptyTuple() {
        let type = TupleType.Builder().build()
        #expect(getDefaultValue(for: type) == "()")
    }

    @Test
    func whenTupleOfKnownValues() {
        let type = TupleType.Builder()
            .element("Int")
            .element("String")
            .build()
        #expect(getDefaultValue(for: type) == "(0, \"\")")
    }

    @Test
    func whenTupleOfMixedKnownAndUnknownValues() {
        let type = TupleType.Builder()
            .element("Int")
            .element("String")
            .element("Unknown")
            .build()
        #expect(getDefaultValue(for: type) == nil)
    }

    @Test
    func whenArray() {
        let type = ArrayType.Builder().type(type: "Any").build()
        #expect(getDefaultValue(for: type) == "[]")
    }

    @Test
    func whenDictionary() {
        let type = DictionaryType.Builder()
            .keyType(type: "Any")
            .valueType(type: "Any")
            .build()
        #expect(getDefaultValue(for: type) == "[:]")
    }

    @Test
    func whenVoid() {
        let type = TypeIdentifier(identifier: "Void")
        #expect(getDefaultValue(for: type) == "()")
    }

    @Test
    func whenVoidTuple() {
        let type = TupleType.Builder().element("Void").build()
        #expect(getDefaultValue(for: type) == "()")
    }

    @Test
    func whenEmpty() {
        let type = TypeIdentifier(identifier: "")
        #expect(getDefaultValue(for: type) == nil)
    }

    private func getDefaultValueForGeneric(for type: String) -> String? {
        return getDefaultValue(
            for: GenericType.Builder(identifier: type).build()
        )
    }

    private func getDefaultValue(for type: String) -> String? {
        return getDefaultValue(for: TypeIdentifier(identifier: type))
    }

    private func getDefaultValue(for type: `Type`) -> String? {
        return DefaultValueVisitor.getDefaultValue(for: type)
    }
}
