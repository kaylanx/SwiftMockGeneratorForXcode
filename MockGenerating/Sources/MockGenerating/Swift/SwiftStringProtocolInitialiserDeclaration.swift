//
//  SwiftStringProtocolInitialiserDeclaration.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

final class SwiftStringProtocolInitialiserDeclaration {

    func transform(initializer: Initializer) -> String {
        let parametersString = initializer.parametersList
            .map { $0.text }
            .joined(separator: ", ")
        return "required init(\(parametersString))"
    }
}
