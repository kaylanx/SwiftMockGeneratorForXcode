//
//  MockTransformer.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

protocol MockTransformer {

    func set(scope: String)

    func add(initializers: Initializer...)
    func add(initializers: [Initializer])

    func add(method: Method)

    func add(methods: Method...)
    func add(methods: [Method])

    func add(property: Property)
    func add(properties: Property...)
    func add(properties: [Property])

    func add(subscript: Subscript)
    func add(subscripts: Subscript...)
    func add(subscripts: [Subscript])

    func set(classInitializers: Initializer...)
    func set(classInitializers: [Initializer])

    func add(classMethods: Method...)
    func add(classMethods: [Method])

    func add(classProperties: Property...)
    func add(classProperties: [Property])

    func add(classSubscripts: Subscript...)
    func add(classSubscripts: [Subscript])

    func generate() -> String
}
