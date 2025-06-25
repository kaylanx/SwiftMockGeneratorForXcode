//
//  SignatureGenerator.swift
//  MockGenerating
//
//  Created by Andy Kayley on 17/06/2025.
//

final class SignatureGenerator: Visitor {

    private var signature = ""

    static func signature(for element: Element) -> String {
        let visitor = SignatureGenerator()
        element.accept(visitor: visitor)
        return visitor.signature
    }

    func visit(initializer type: Initializer) {
        signature = "init(\(getParametersSignature(parameters: type.parametersList)))"
    }

    func visit(property type: Property) {
        signature = type.name
    }

    func visit(method type: Method) {
        let parameters = getParametersSignature(parameters: type.parametersList)
        let returnType = getReturnSignature(declaration: type)
        signature = "\(type.name)(\(parameters))\(returnType)"
    }

    func visit(subscript type: Subscript) {
        let parameters = getParametersSignature(parameters: type.parameters)
        signature = "subscript(\(parameters)):\(type.returnType.resolvedType.text)"
    }

    func visit(parameter type: Parameter) {
        let name: String
        if let external = type.externalName, !external.isEmpty {
            name = external
        } else {
            name = type.internalName
        }
        signature = "\(name):\(type.type.resolvedType.text)"
    }

    private func getParametersSignature(parameters: [Parameter]) -> String {
        return parameters.map { SignatureGenerator.signature(for: $0) }.joined(separator: ",")
    }

    private func getReturnSignature(declaration: Method) -> String {
        let text = declaration.returnType.resolvedType.text
        return text.isEmpty ? "" : ":\(text)"
    }
}
