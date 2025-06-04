//
//  Class.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

class Class: TypeDeclaration {
    let inheritedClass: Class?

    init(
        initializers: [Initializer],
        properties: [Property],
        methods: [Method],
        subscripts: [Subscript],
        inheritedClass: Class?
    ) {
        self.inheritedClass = inheritedClass
        super.init(
            initializers: initializers,
            properties: properties,
            methods: methods,
            subscripts: subscripts,
            protocols: []
        )
    }

    class Builder {
        private var methods: [Method] = []
        private var properties: [Property] = []
        private var initializers: [Initializer] = []
        private var subscripts: [Subscript] = []
        private var superclass: Class?

        @discardableResult
        func initializer(_ build: (Initializer.Builder) -> Void) -> Builder {
            let builder = Initializer.Builder()
            build(builder)
            initializers.append(builder.build())
            return self
        }

        @discardableResult
        func property(_ name: String, _ build: (Property.Builder) -> Void) -> Builder {
            let builder = Property.Builder(name: name)
            build(builder)
            properties.append(builder.build())
            return self
        }

        @discardableResult
        func method(_ name: String, _ build: (Method.Builder) -> Void) -> Builder {
            let builder = Method.Builder(name: name)
            build(builder)
            methods.append(builder.build())
            return self
        }

        @discardableResult
        func `subscript`(
            _ returnType: `Type`,
            _ build: (Subscript.Builder) -> Void
        ) -> Builder {
            let builder = Subscript.Builder(type: returnType)
            build(builder)
            subscripts.append(builder.build())
            return self
        }

        @discardableResult
        func superclass(_ build: (Builder) -> Void) -> Builder {
            let builder = Builder()
            build(builder)
            self.superclass = builder.build()
            return self
        }

        func build() -> Class {
            return Class(
                initializers: initializers,
                properties: properties,
                methods: methods,
                subscripts: subscripts,
                inheritedClass: superclass
            )
        }
    }
}
