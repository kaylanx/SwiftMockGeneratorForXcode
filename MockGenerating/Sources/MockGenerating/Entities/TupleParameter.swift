//
//  TupleParameter.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

struct TupleParameter {
    let name: String
    let type: String
    let resolvedType: String

    init(name: String, type: String, resolvedType: String) {
        self.name = name
        self.type = type
        self.resolvedType = resolvedType
    }

    init (name: String, type: String) {
        self.init(name: name, type: type, resolvedType: type)
    }
}
