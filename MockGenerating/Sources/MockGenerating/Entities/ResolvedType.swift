//
//  ResolvedType.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

import Foundation

final class ResolvedType: Sendable, Equatable {

    static func == (lhs: ResolvedType, rhs: ResolvedType) -> Bool {
        lhs.originalType.text == rhs.originalType.text
    }

    static let implicit: ResolvedType = {
        ResolvedType(
            originalType: TypeIdentifier(identifier: ""),
            resolvedType: TypeIdentifier(identifier: "")
        )
    }()
    
    let originalType: `Type`
    let resolvedType: `Type`

    init(originalType: `Type`, resolvedType: `Type`) {
        self.originalType = originalType
        self.resolvedType = resolvedType
    }

    class Builder {
        private var originalType: TypeIdentifier
        private var resolvedType: TypeIdentifier

        init(type: String) {
            let identifier = TypeIdentifier(identifier: type)
            self.originalType = identifier
            self.resolvedType = identifier
        }

        init(originalType: TypeIdentifier, resolvedType: TypeIdentifier) {
            self.originalType = originalType
            self.resolvedType = resolvedType
        }

        func build() -> ResolvedType {
            return ResolvedType(originalType: originalType, resolvedType: resolvedType)
        }
    }
}
