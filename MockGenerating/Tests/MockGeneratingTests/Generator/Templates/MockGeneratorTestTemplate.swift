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

    func getExpected(type: MockType) -> String? {
        readFile(from: type.directoryName)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func readFile(from directory: String) -> String? {
        guard let expectedFile = Bundle.module.url(forResource: "Expectations/\(directory)/\(expectedSwiftFileName)", withExtension: "swift") else {
            return nil
        }
        return try? String(contentsOf: expectedFile, encoding: .utf8)
    }
}
