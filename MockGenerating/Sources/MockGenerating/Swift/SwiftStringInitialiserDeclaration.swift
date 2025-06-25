//
//  SwiftStringInitialiserDeclaration.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

final class SwiftStringInitialiserDeclaration {
    func transform(call: InitialiserCall) -> String {
        return if call.parameters.isEmpty {
            "override init()"
        } else {
            "convenience init()"
        }
    }
}
