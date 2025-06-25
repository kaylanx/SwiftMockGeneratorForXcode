//
//  GeneratorTestTemplate.swift
//  MockGenerating
//
//  Created by Andy Kayley on 17/06/2025.
//

import Foundation
@testable import MockGenerating

protocol GeneratorTestTemplate {
    var expectedSwiftFileName: String { get }
    func build(generator: Generator)
}

extension GeneratorTestTemplate {
    func getExpected(type: MockType) -> String? {
        readFile(from: type.directoryName)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func readFile(from directory: String) -> String? {
        guard let expectedFile = Bundle.module.url(forResource: "Expectations/\(directory)/protocol/\(expectedSwiftFileName)", withExtension: "swift") else {
            return nil
        }
        return try? String(contentsOf: expectedFile, encoding: .utf8)
    }
}
