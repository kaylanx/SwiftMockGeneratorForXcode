//
//  MockClass.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

public class MockClass: TypeDeclaration {
    public let inheritedClass: Class?
    let scope: String?

    public init(inheritedClass: Class?, protocols: [`Protocol`], scope: String?) {
        self.inheritedClass = inheritedClass
        self.scope = scope
        super.init(
            initializers: [],
            properties: [],
            methods: [],
            subscripts: [],
            protocols: protocols
        )
    }

    class Builder {
        private var protocols: [`Protocol`] = []
        private var superclass: Class?
        private var scope: String?

        func superclass(_ build: (Class.Builder) -> Void) -> Builder {
            let builder = Class.Builder()
            build(builder)
            self.superclass = builder.build()
            return self
        }

        func `protocol`(_ build: (`Protocol`.Builder) -> Void) -> Builder {
            let builder = `Protocol`.Builder()
            build(builder)
            self.protocols.append(builder.build())
            return self
        }

        func scope(_ scope: String) -> Builder {
            self.scope = scope
            return self
        }

        func build() -> MockClass {
            return MockClass(inheritedClass: superclass, protocols: protocols, scope: scope)
        }
    }
}
