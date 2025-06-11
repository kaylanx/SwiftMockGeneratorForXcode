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

