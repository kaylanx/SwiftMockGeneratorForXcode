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

    @Test(
        "Should Return Simple Protocol",
        .disabled("Re-enable when protocols implemented"),
        arguments: arguments
    )
    mutating func shouldReturnSimpleProtocol(type: MockViewType) async throws {
        try await setUp(type: type)
        try runTest(template: SimpleProtocolTemplate())
    }

    @Test(
        "Should Return Intializer With Arguments",
        arguments: arguments
    )
    mutating func shouldReturnArgumentsInitializer(type: MockViewType) async throws {
        try await setUp(type: type)
        try runTest(template: ArgumentsInitializerTemplate())
    }

    @Test(
        "Should Return Open Intializer",
        arguments: arguments
    )
    mutating func shouldReturnOpenIntializer(type: MockViewType) async throws {
        try await setUp(type: type)
        try runTest(template: OpenInitializerTemplate())
    }

    private func runTest(template: MockGeneratorTestTemplate) throws {
        template.build(generator: generator)
        generator.generate()
        let expected = try #require(template.getExpected(type: .dummy))
        #expect(view.rendered == expected)
    }
}

