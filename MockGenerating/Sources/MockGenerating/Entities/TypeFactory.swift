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
    func function(_ build: (FunctionType.Builder) -> Void) -> Builder {
        let builder = FunctionType.Builder()
        build(builder)
        getType(builder.build())
        return previousBuilder
    }

    @discardableResult
    func optional(_ build: (OptionalType.Builder) -> Void) -> Builder {
        let builder = OptionalType.Builder()
        build(builder)
        getType(builder.build())
        return previousBuilder
    }

    @discardableResult
    func array(_ build: (ArrayType.Builder) -> Void) -> Builder {
        let builder = ArrayType.Builder()
        build(builder)
        getType(builder.build())
        return previousBuilder
    }
//
//    func dictionary(_ build: (DictionaryType.Builder) -> Void) -> B {
//        let builder = DictionaryType.Builder()
//        build(builder)
//        getType(builder.build())
//        return previousBuilder
//    }
//
//    func generic(identifier: String, _ build: (GenericType.Builder) -> Void) -> B {
//        let builder = GenericType.Builder(identifier: identifier)
//        build(builder)
//        getType(builder.build())
//        return previousBuilder
//    }

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
