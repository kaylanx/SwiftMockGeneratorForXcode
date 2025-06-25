//
//  SwiftStringTupleForwardCall.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//

final class SwiftStringTupleForwardCall {

    private let keywordStore = KeywordsStore()

    func transform(property: TuplePropertyDeclaration) -> String {
        "(" + property.parameters.map { buildParameter(parameter: $0) }.joined(separator: ", ") + ")"
    }

    private func buildParameter(parameter: TupleParameter) -> String {
        if parameter.type == "Void" || parameter.type == "()" {
            "()"
        } else if keywordStore.isSwiftKeyword(input: parameter.name) {
            "`" + parameter.name + "`"
        } else {
            parameter.name
        }
    }
}
