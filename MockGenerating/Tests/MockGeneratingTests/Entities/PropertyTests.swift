//
//  PropertyTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

import Testing
@testable import MockGenerating

struct PropertyTests {

    @Test("Trims 'Gets Set' From Signature")
    func trimGetsSetFromSignature() {
        let property = Property(
            name: "",
            type: TypeIdentifiers.empty.type,
            isWritable: false,
            declarationText: "   var prop: Type{ get set }"
        )
        #expect(property.getTrimmedDeclarationText() == "var prop: Type")
    }

    @Test("Trims 'Get Set' And Whitespace From Signature")
    func trimGetSetAndWhitespaceFromSignature() {
        let property = Property(
            name: "",
            type: TypeIdentifiers.empty.type,
            isWritable: false,
            declarationText: "   var prop: Type    { get set }"
        )
        #expect(property.getTrimmedDeclarationText() == "var prop: Type")
    }

    @Test("Trims Whitespace When No 'Get Set' Clause")
    func trimWhitespaceWhenNoGetSetClause() {
        let property = Property(
            name: "",
            type: TypeIdentifiers.empty.type,
            isWritable: false,
            declarationText: "   var prop: Type    "
        )
        #expect(property.getTrimmedDeclarationText() == "var prop: Type")
    }

    @Test("Trims Whitespace And Newlines And Tabs")
    func trimWhitespaceAndNewlinesAndTabs() {
        let property = Property(
            name: "",
            type: TypeIdentifiers.empty.type,
            isWritable: false,
            declarationText: " \n\tvar prop: Type \t\n {\n get set \n}   "
        )
        #expect(property.getTrimmedDeclarationText() == "var prop: Type")
    }
}
