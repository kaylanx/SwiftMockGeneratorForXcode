//
//  Protocol.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

public final class `Protocol`: TypeDeclaration {

    override public init(
        initializers: [Initializer],
        properties: [Property],
        methods: [Method],
        subscripts: [Subscript],
        protocols: [`Protocol`]
    ) {
        super.init(
            initializers: initializers,
            properties: properties,
            methods: methods,
            subscripts: subscripts,
            protocols: protocols
        )
    }

    class Builder {

        private var methods = [Method]()
        private var properties = [Property]()
        private var initializers = [Initializer]()
        private var subscripts = [Subscript]()
        private var protocols = [`Protocol`]()

        @discardableResult
        func initializer(build: (Initializer.Builder) -> Void) -> Builder {
            let builder = Initializer.Builder()
            build(builder)
            initializers.append(builder.build())
            return self
        }

        @discardableResult
        func property(name: String, build: (Property.Builder) -> Void) -> Builder {
            let builder = Property.Builder(name: name)
            build(builder)
            properties.append(builder.build())
            return self
        }

        @discardableResult
        func method(name: String, build: (Method.Builder) -> Void) -> Builder {
            let builder = Method.Builder(name: name)
            build(builder)
            methods.append(builder.build())
            return self
        }

        @discardableResult
        func `subscript`(type: Type, build: (Subscript.Builder) -> Void) -> Builder {
            let builder = Subscript.Builder(type: type)
            build(builder)
            subscripts.append(builder.build())
            return self
        }

        @discardableResult
        func `protocol`(build: (`Protocol`.Builder) -> Void) -> Builder {
            let builder = `Protocol`.Builder()
            build(builder)
            protocols.append(builder.build())
            return self
        }

        func build() -> `Protocol` {
            Protocol(
                initializers: initializers,
                properties: properties,
                methods: methods,
                subscripts: subscripts,
                protocols: protocols
            )
        }
    }
}
