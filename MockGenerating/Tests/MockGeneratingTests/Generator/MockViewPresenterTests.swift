//
//  MockViewPresenterTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//

import Foundation
import Testing
@testable import MockGenerating

struct MockViewPresenterTests {

    private static let arguments: [MockViewType] = [.dummy]

    private var generator: MockViewPresenter!
    private var view: MustacheMockView!

    private mutating func setUp(type: MockViewType) async throws {
        view = try await MustacheMockView(type: type)
        generator = MockViewPresenter(view: view)
    }

    @Test(
        "Should Return Empty String When Nothing To Mock",
        arguments: arguments
    )
    mutating func testShouldReturnEmptyString_whenNothingToMock(type: MockViewType) async throws {
        try await setUp(type: type)
        #expect(generator.generate().isEmpty)
    }

    @Test("Should Return Simple Protocol")
    mutating func shouldReturnSimpleProtocol() async throws {
        try await setUp(type: .dummy)
        try runTest(template: SimpleProtocolTest())
    }

    @Test("Should Return Open Intializer")
    mutating func shouldReTurnOpenIntializer() async throws {
        try await setUp(type: .dummy)
        try runTest(template: OpenInitializerTest())
    }

    private func runTest(template: MockGeneratorTestTemplate) throws {
        template.build(generator: generator)
        generator.generate()
        let expected = try #require(template.getExpected(type: .dummy))
        #expect(view.rendered == expected)
    }
}

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
            print(">>> fixtureFile is nil")
            return nil
        }
        print(">>> \(String(describing: fixtureFile))")

        return try? String(contentsOf: fixtureFile, encoding: .utf8)
    }
}

final class SimpleProtocolTest: MockGeneratorTestTemplate {

    let expectedSwiftFileName = "SimpleProtocolTest"

    func build(generator: MockTransformer) {
        generator.add(
            method: Method.Builder(name: "simpleMethod").build()
        )
    }
}

final class OpenInitializerTest: MockGeneratorTestTemplate {

    let expectedSwiftFileName = "OpenInitializerTest"

    func build(generator: MockTransformer) {
        generator.set(classInitializers:
            Initializer.Builder()
            .parameter("a") { $0.type().optional { $0.type(type: "String") } }
                .build()
        )
        generator.set(scope: "open")
    }
}

