//
//  Untitled.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

class CreateConvenienceInitialiser {

    func transform(initializer: Initializer) -> InitialiserCall? {
        guard emptyInitialiserCanBeInferred(initializer: initializer) == false else {
            return nil
        }
        return InitialiserCall(
            parameters: initializer.parametersList,
            isFailable: initializer.isFailable,
            async: initializer.async,
            throws: initializer.throws
        )
    }

    private func emptyInitialiserCanBeInferred(initializer: Initializer) -> Bool {
        initializer.parametersList.isEmpty && !initializer.isFailable
    }
}

