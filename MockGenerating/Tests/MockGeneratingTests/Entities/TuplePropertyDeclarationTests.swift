//
//  TuplePropertyDeclarationTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

import Testing
@testable import MockGenerating

struct TuplePropertyDeclarationTests {

    @Test("Should Create TuplePropertyDeclaration With Text")
    func shouldCreateTuplePropertyDeclarationWithText() async throws {
        let tupleDeclaration = TuplePropertyDeclaration(
            parameters: [
                TupleParameter(name: "a", type: "A")
            ],
            text: "text"
        )
        #expect(tupleDeclaration.parameters.count == 1)
        #expect(tupleDeclaration.parameters.first?.name == "a")
        #expect(tupleDeclaration.parameters.first?.type == "A")
        #expect(tupleDeclaration.text == "text")
    }

    @Test("Should Create TuplePropertyDeclaration Without Text")
    func shouldCreateTuplePropertyDeclarationWithoutText() async throws {
        let tupleDeclaration = TuplePropertyDeclaration(
            parameters: [
                TupleParameter(name: "a", type: "A")
            ]
        )
        #expect(tupleDeclaration.parameters.count == 1)
        #expect(tupleDeclaration.parameters.first?.name == "a")
        #expect(tupleDeclaration.parameters.first?.type == "A")
        #expect(tupleDeclaration.text == "(a: A)")
    }

    @Test("Should Create TuplePropertyDeclaration With Multiple Parameters Without Text")
    func shouldCreateTuplePropertyWithMultipleParametersDeclarationWithoutText() async throws {
        let tupleDeclaration = TuplePropertyDeclaration(
            parameters: [
                TupleParameter(name: "a", type: "A"),
                TupleParameter(name: "b", type: "B"),
                TupleParameter(name: "c", type: "C"),
            ]
        )
        #expect(tupleDeclaration.parameters.count == 3)
        #expect(tupleDeclaration.text == "(a: A, b: B, c: C)")
    }
}
