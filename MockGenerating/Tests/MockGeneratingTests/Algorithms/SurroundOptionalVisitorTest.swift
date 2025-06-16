//
//  SurroundOptionalVisitorTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//
import Testing
@testable import MockGenerating

struct SurroundOptionalVisitorTest  {

    @Test
    func shouldSurroundType() throws {
        let type = TypeIdentifier.Builder("A").build()
        let optional = try #require(SurroundOptionalVisitor.surround(
            type: type,
            unwrapped: false
        ) as? OptionalType)
        #expect(optional.isImplicitlyUnwrapped == false)
        #expect(optional.type.text == type.text)
        #expect(optional.text == "A?")
    }

    @Test
    func shouldSurroundFunctionTypeWithTupleToo() throws {
        let type = FunctionType.Builder().build()
        let optional = try #require(SurroundOptionalVisitor.surround(
            type: type,
            unwrapped: false
        ) as? OptionalType)

        let tuple = try #require(optional.type as? TupleType)
        #expect(tuple.types.count == 1)
        #expect(tuple.types[0].text == type.text)
        #expect(tuple.types[0].text == "() -> ()")
    }

    @Test
    func shouldSurroundTypeWithIUO() throws {
        let type = TypeIdentifier.Builder("A").build()
        let optional = try #require(SurroundOptionalVisitor.surround(
            type: type,
            unwrapped: true
        ) as? OptionalType)
        #expect(optional.isImplicitlyUnwrapped == true)
        #expect(optional.type.text == type.text)
        #expect(optional.text == "A!")
    }

    @Test
    func shouldSurroundFunctionTypeWithTupleTooWithIUO() throws {
        let type = FunctionType.Builder().build()
        let optional = try #require(SurroundOptionalVisitor.surround(
            type: type,
            unwrapped: true
        ) as? OptionalType)
        #expect(optional.isImplicitlyUnwrapped == true)
        #expect(optional.text == "(() -> ())!")
    }
}
