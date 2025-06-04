//
//  TypeDeclaration.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

class TypeDeclaration {
    let initializers: [Initializer]
    let properties: [Property]
    let methods: [Method]
    let subscripts: [Subscript]
    let protocols: [`Protocol`]

    init(
        initializers: [Initializer],
        properties: [Property],
        methods: [Method],
        subscripts: [Subscript],
        protocols: [`Protocol`]
    ) {
        self.initializers = initializers
        self.properties = properties
        self.methods = methods
        self.subscripts = subscripts
        self.protocols = protocols
    }
}
