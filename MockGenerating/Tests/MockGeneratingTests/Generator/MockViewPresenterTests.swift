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

    private static let arguments: [MockViewType] = [
        .dummy,
        .partial,
        .spy,
        .stub
    ]

    private var generator: MockViewPresenter!
    private var view: MustacheMockView!

    private mutating func setUp(
        type: MockViewType
    ) async throws {
        view = try await MustacheMockView(type: type)
        generator = MockViewPresenter(view: view)
    }

    @Test(
        "Should Correctly Render Empty String When Nothing To Mock",
        arguments: arguments
    )
    mutating func testShouldCorrectlyRenderEmptyString_whenNothingToMock(
        type: MockViewType
    ) async throws {
        try await setUp(type: type)
        #expect(generator.generate().isEmpty)
    }

    @Test(
        "Should Correctly Render Simple Protocol",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderSimpleProtocol(
        type: MockViewType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: SimpleProtocolTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Method Parameter",
        arguments: arguments
    )
    mutating func shoudlCorrectlyRenderMethodParameter(
        type: MockViewType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: MethodParameterTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Intializer With Arguments",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderArgumentsInitializer(
        type: MockViewType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: ArgumentsInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Optional Intializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderOptionalInitializer(
        type: MockViewType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: FailableInitialzerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render No Arguments Optional Initializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderNoArgumentsOptionalInitializer(
        type: MockViewType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: NoArgumentFailableInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Protocol Initializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderProtocolInitializer(
        type: MockViewType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: ProtocolInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Simplest Initializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderSimplestInitializer(
        type: MockViewType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: SimplestClassInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Open Intializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderOpenIntializer(
        type: MockViewType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: OpenInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Throwing Initializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderThrowingInitializer(
        type: MockViewType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: ThrowingInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Async Initializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderAsyncInitializer(
        type: MockViewType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: AsyncInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Async Throwing Initializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderAsyncThrowingInitializer(
        type: MockViewType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: AsyncThrowingInitializerTemplate(), for: type)
    }

    private func runTest(
        template: MockGeneratorTestTemplate,
        for type: MockViewType
    ) throws {
        template.build(generator: generator)
        generator.generate()
        let expected = try #require(template.getExpected(type: type))
        #expect(view.rendered == expected)
    }
}
