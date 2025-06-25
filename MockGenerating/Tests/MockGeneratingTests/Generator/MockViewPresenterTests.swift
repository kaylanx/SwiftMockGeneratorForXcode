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

    private static let arguments: [MockType] = [
        .dummy,
        .partial,
        .spy,
        .stub
    ]

    private var generator: MockViewPresenter!
    private var view: MustacheMockView!

    private mutating func setUp(
        type: MockType
    ) async throws {
        view = try await MustacheMockView(type: type)
        generator = MockViewPresenter(view: view)
    }

    @Test(
        "Should Correctly Render Empty String When Nothing To Mock",
        arguments: arguments
    )
    mutating func testShouldCorrectlyRenderEmptyString_whenNothingToMock(
        type: MockType
    ) async throws {
        try await setUp(type: type)
        #expect(generator.generate().isEmpty)
    }

    @Test(
        "Should Correctly Render Simple Protocol",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderSimpleProtocol(
        type: MockType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: SimpleProtocolTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Method Parameter",
        arguments: arguments
    )
    mutating func shoudlCorrectlyRenderMethodParameter(
        type: MockType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: MethodParameterTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Intializer With Arguments",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderArgumentsInitializer(
        type: MockType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: ArgumentsInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Optional Intializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderOptionalInitializer(
        type: MockType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: FailableInitialzerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render No Arguments Optional Initializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderNoArgumentsOptionalInitializer(
        type: MockType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: NoArgumentFailableInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Protocol Initializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderProtocolInitializer(
        type: MockType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: ProtocolInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Simplest Initializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderSimplestInitializer(
        type: MockType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: SimplestClassInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Open Intializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderOpenIntializer(
        type: MockType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: OpenInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Throwing Initializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderThrowingInitializer(
        type: MockType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: ThrowingInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Async Initializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderAsyncInitializer(
        type: MockType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: AsyncInitializerTemplate(), for: type)
    }

    @Test(
        "Should Correctly Render Async Throwing Initializer",
        arguments: arguments
    )
    mutating func shouldCorrectlyRenderAsyncThrowingInitializer(
        type: MockType
    ) async throws {
        try await setUp(type: type)
        try runTest(template: AsyncThrowingInitializerTemplate(), for: type)
    }

    @Test
    mutating func shouldForwardToSuper() async throws {
        try await setUp(type: .partial)
        try runTest(template: ForwardToSuperTemplate(), for: .partial)
    }

    private func runTest(
        template: MockGeneratorTestTemplate,
        for type: MockType
    ) throws {
        template.build(generator: generator)
        generator.generate()
        let expected = try #require(template.getExpected(type: type))
        StringCompareTestHelper.expectEqualStrings(view.rendered, expected)
    }
}
