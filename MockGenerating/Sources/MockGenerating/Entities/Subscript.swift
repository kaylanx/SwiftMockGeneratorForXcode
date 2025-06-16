//
//  Subscript.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

class Subscript: Element {
    let returnType: ResolvedType
    let parameters: [Parameter]
    let isWritable: Bool
    let declarationText: String

    init(
        returnType: ResolvedType,
        parameters: [Parameter],
        isWritable: Bool,
        declarationText: String
    ) {
        self.returnType = returnType
        self.parameters = parameters
        self.isWritable = isWritable
        self.declarationText = declarationText
    }

    func accept(visitor: Visitor) {
        visitor.visit(subscript: self)
    }

    class Builder {
        private let returnType: ResolvedType
        private var parameters = [Parameter]()
        private var isWritable = true

        init(returnType: ResolvedType) {
            self.returnType = returnType
        }

        init(type: `Type`) {
            self.returnType = ResolvedType(originalType: type, resolvedType: type)
        }

        func parameter(name: String, build: (Parameter.Builder) -> Void) -> Builder {
            return parameter(externalName: nil, internalName: name, build: build)
        }

        @discardableResult
        func parameter(externalName: String?, internalName: String, build: (Parameter.Builder) -> Void) -> Builder {
            let builder = Parameter.Builder(externalName: externalName, internalName: internalName)
            build(builder)
            return parameter(parameter: builder.build())
        }

        private func parameter(parameter: Parameter) -> Builder {
            parameters.append(parameter)
            return self
        }

        func readonly() -> Builder {
            isWritable = false
            return self
        }

        func build() -> Subscript {
            return Subscript(
                returnType: returnType,
                parameters: parameters,
                isWritable: isWritable,
                declarationText: getDeclarationText()
            )
        }

        private func getDeclarationText() -> String {
            return "subscript(\(getParametersText())) -> \(returnType.originalType.text)"
        }

        private func getParametersText() -> String {
            parameters
                .map { $0.text }
                .joined(separator: ", ")
        }
    }
}
