//
//  TuplePropertyDeclaration.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

struct TuplePropertyDeclaration {

    let parameters: [TupleParameter]
    let text: String

    init(parameters: [TupleParameter], text: String) {
        self.parameters = parameters
        self.text = text
    }

    init (parameters: [TupleParameter]) {
        let text = TuplePropertyDeclaration.createType(parameters: parameters)
        self.init(parameters: parameters, text: text)
    }

    private static func createType(parameters: [TupleParameter]) -> String {
        let params = parameters
            .map { buildParameterString(parameter: $0) }
            .joined(separator: ", ")
        return "(\(params))"
    }

    private static func buildParameterString(parameter: TupleParameter) -> String {
        if parameter.name.isEmpty {
            return parameter.type
        }
        return "\(parameter.name): \(parameter.type)"
    }
}
