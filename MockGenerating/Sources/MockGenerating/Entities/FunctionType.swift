//
//  FunctionType.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

struct FunctionType: Type {
    let arguments: [`Type`]
    let returnType: `Type`
    let `async`: Bool
    let `throws`: Bool

    var text: String {
        let argsText = arguments.map { $0.text }.joined(separator: ", ")
        let asyncText = `async` ? "async " : ""
        let throwsText = `throws` ? "throws " : ""
        return "(\(argsText)) \(asyncText)\(throwsText)-> \(returnType.text)"
    }

    init(
        arguments: [`Type`],
        returnType: `Type`,
        async: Bool,
        throws: Bool
    ) {
        self.arguments = arguments
        self.returnType = returnType
        self.async = `async`
        self.throws = `throws`
    }

    func accept(visitor: Visitor) {
        visitor.visit(functionType: self)
    }

    func deepCopy() -> FunctionType {
        return FunctionType(
            arguments: arguments.map { CopyVisitor.copy($0) },
            returnType: CopyVisitor.copy(returnType),
            async: `async`,
            throws: `throws`
        )
    }

    class Builder {
        private var arguments: [`Type`] = []
        private var _returnType: `Type` = TypeIdentifier.emptyTuple
        private var _async: Bool = false
        private var _throws: Bool = false

        func `async`() -> Builder {
            self._async = true
            return self
        }

        func `throws`() -> Builder {
            self._throws = true
            return self
        }

        func argument(type: String) -> Builder {
            self.arguments.append(TypeIdentifier(identifier: type))
            return self
        }

        func argument() -> TypeFactory<Builder> {
            return TypeFactory(previousBuilder: self) {
                self.arguments.append($0)
            }
        }

        func returnType(type: String) -> Builder {
            self._returnType = TypeIdentifier(identifier: type)
            return self
        }

        func returnType() -> TypeFactory<Builder> {
            return TypeFactory(previousBuilder: self) {
                self._returnType = $0
            }
        }

        func build() -> FunctionType {
            return FunctionType(
                arguments: arguments,
                returnType: _returnType,
                async: _async,
                throws: _throws
            )
        }
    }
}
