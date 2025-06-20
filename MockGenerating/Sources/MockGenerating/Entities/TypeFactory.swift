//
//  TypeFactory.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

class TypeFactory<Builder> {
    private let previousBuilder: Builder
    private let getType: (`Type`) -> Void

    init(previousBuilder: Builder, getType: @escaping (`Type`) -> Void) {
        self.previousBuilder = previousBuilder
        self.getType = getType
    }

    @discardableResult
    func function(build: (FunctionType.Builder) -> Void) -> Builder {
        let builder = FunctionType.Builder()
        build(builder)
        getType(builder.build())
        return previousBuilder
    }

    @discardableResult
    func optional(build: (OptionalType.Builder) -> Void) -> Builder {
        let builder = OptionalType.Builder()
        build(builder)
        getType(builder.build())
        return previousBuilder
    }

    @discardableResult
    func array(build: (ArrayType.Builder) -> Void) -> Builder {
        let builder = ArrayType.Builder()
        build(builder)
        getType(builder.build())
        return previousBuilder
    }

    @discardableResult
    func dictionary(build: (DictionaryType.Builder) -> Void) -> Builder {
        let builder = DictionaryType.Builder()
        build(builder)
        getType(builder.build())
        return previousBuilder
    }

    func generic(identifier: String, build: (GenericType.Builder) -> Void) -> Builder {
        let builder = GenericType.Builder(identifier: identifier)
        build(builder)
        getType(builder.build())
        return previousBuilder
    }

    func bracket() -> TypeFactory<Builder> {
        return TypeFactory<Builder>(previousBuilder: previousBuilder) {
            self.getType(TupleType.Builder().element($0).build())
        }
    }

    @discardableResult
    func type(_ type: String) -> Builder {
        getType(TypeIdentifier(identifier: type))
        return previousBuilder
    }

    @discardableResult
    func typeIdentifier(
        identifier: String,
        _ build: (TypeIdentifier.Builder) -> Void
    ) -> Builder {
        let builder = TypeIdentifier.Builder(identifier: identifier)
        build(builder)
        getType(builder.build())
        return previousBuilder
    }

    @discardableResult
    func tuple(_ build: (TupleType.Builder) -> Void) -> Builder {
        let builder = TupleType.Builder()
        build(builder)
        getType(builder.build())
        return previousBuilder
    }
}
