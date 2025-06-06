//
//  PropertyDeclaration.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

struct PropertyDeclaration {
    let name: String
    let type: String

    init(name: String, type: String) {
        self.name = name
        self.type = type
    }

    static let empty = PropertyDeclaration(name: "", type: "")
}
