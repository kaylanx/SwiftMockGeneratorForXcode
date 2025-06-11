//
//  MockGeneratorTestTemplate.swift
//  MockGenerating
//
//  Created by Andy Kayley on 11/06/2025.
//

import Foundation
@testable import MockGenerating

protocol MockGeneratorTestTemplate {
    var expectedSwiftFileName: String { get }
    func build(generator: MockTransformer)
}

extension MockGeneratorTestTemplate {

    func getExpected(type: MockViewType) -> String? {
        readFile(from: type.directoryName)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func readFile(from directory: String) -> String? {
        guard let fixtureFile = Bundle.module.url(forResource: "Fixtures/\(directory)/\(expectedSwiftFileName)", withExtension: "swift") else {
            return nil
        }
        return try? String(contentsOf: fixtureFile, encoding: .utf8)
    }
}
