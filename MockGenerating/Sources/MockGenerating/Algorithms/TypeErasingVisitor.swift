//
//  TypeErasingVisitor.swift
//  MockGenerating
//
//  Created by Andy Kayley on 13/06/2025.
//

final class TypeErasingVisitor: RecursiveVisitor {

    static func erase(type: `Type`, genericIdentifiers: [String]) {
        let visitor = TypeErasingVisitor(genericIdentifiers: genericIdentifiers)
        type.accept(visitor: visitor)
    }

    private let genericIdentifiers: [String]

    init(genericIdentifiers: [String]) {
        self.genericIdentifiers = genericIdentifiers
    }

    func visit(typeIdentifier type: TypeIdentifier) {
        if genericIdentifiers.contains(type.firstIdentifier) {
            type.identifiers = ["Any"]
        }
    }

    override func visit(dictionaryType type: DictionaryType) {
        if (genericIdentifiers.contains(type.keyType.text)) {
            type.keyType = TypeIdentifier.Builder("AnyHashable").build()
        }
        super.visit(dictionaryType: type)
    }
}
