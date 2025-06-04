//
//  GenericType.swift
//  MockGenerating
//
//  Created by Andy Kayley on 04/06/2025.
//

struct GenericType: `Type` {

    let identifier: String
    let arguments: [`Type`]

    var text: String {
        return "<\(arguments.map(\.text).joined(separator: ", "))>\(identifier)"
    }

    func accept(visitor: any Visitor) {
        visitor.visit(genericType: self)
    }

    func deepCopy() -> GenericType {
        GenericType(
            identifier: identifier,
            arguments: CopyVisitor.copy(arguments)
        )
    }

    class Builder {

        let identifier: String
        private var arguments = [`Type`]()

        init(identifier: String) {
            self.identifier = identifier
        }

        @discardableResult
        func argument(identifier: String) -> Builder {
            arguments.append(TypeIdentifier(identifier: identifier))
            return self
        }

        @discardableResult
        func argument() -> TypeFactory<Builder> {
            TypeFactory(previousBuilder: self) {
                self.arguments.append($0)
            }
        }

        func build() -> GenericType {
            GenericType(identifier: identifier, arguments: arguments)
        }
    }
}
