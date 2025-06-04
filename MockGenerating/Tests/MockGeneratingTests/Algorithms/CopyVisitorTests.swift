//
//  CopyVisitorTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

import Testing
@testable import MockGenerating

struct CopyVisitorTests {

    @Test("Should Copy")
    func shouldCopy() {
        expectCopied(original: TypeIdentifier(identifier: "Type"))
        expectCopied(original: FunctionType.Builder().build())
        expectCopied(original: OptionalType.Builder().build())
        expectCopied(original: TupleType.Builder().element("Type").build())
        expectCopied(original: ArrayType.Builder().build())
        expectCopied(original: DictionaryType.Builder().build())
        expectCopied(original: GenericType.Builder(identifier: "Type").build())
    }

    private func expectCopied(original: `Type`) {
        let copied = CopyVisitor.copy(original)

        if type(of: original) is AnyObject.Type,
           type(of: copied) is AnyObject.Type {
            let originalId = ObjectIdentifier(original as AnyObject)
            let copiedId = ObjectIdentifier(copied as AnyObject)
            #expect(originalId == copiedId, "Expected different object instances")
        }

        #expect(copied.text == original.text)
    }
}
