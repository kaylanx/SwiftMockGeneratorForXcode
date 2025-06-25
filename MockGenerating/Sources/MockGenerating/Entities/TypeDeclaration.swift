//
//  TypeDeclaration.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

public class TypeDeclaration {
    public let initializers: [Initializer]
    public let properties: [Property]
    public let methods: [Method]
    public let subscripts: [Subscript]
    public let protocols: [`Protocol`]

    public init(
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
