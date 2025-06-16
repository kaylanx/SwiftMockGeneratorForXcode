//
//  MakeFunctionCallVisitor.swift
//  MockGenerating
//
//  Created by Andy Kayley on 16/06/2025.
//

final class MakeFunctionCallVisitor: Visitor {

    static func make(element: Element) -> String? {
        let visitor = MakeFunctionCallVisitor()
        element.accept(visitor: visitor)
        return visitor.result
    }

    private var result: String? = nil

    func visit(method type: Method) {
        result = "\(type.name)(\(parseParameters(parameters: type.parametersList, useImplicitLabels: false)))"
    }

    func visit(subscript type: Subscript) {
        result = "[\(parseParameters(parameters: type.parameters, useImplicitLabels: true))]"
    }

    private func parseParameters(
        parameters: [Parameter],
        useImplicitLabels: Bool
    ) -> String {
        parameters.map { parameter in
            let external = parameter.externalName
            let internalName = parameter.internalName

            return if external == "_" {
                internalName
            } else if useImplicitLabels && external == nil {
                internalName
            } else {
                "\(external ?? internalName): \(internalName)"
            }
        }.joined(separator: ", ")
    }

}
