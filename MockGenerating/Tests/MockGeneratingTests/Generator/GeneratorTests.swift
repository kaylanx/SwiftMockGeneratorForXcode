//
//  GeneratorTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 17/06/2025.
//
import Testing
@testable import MockGenerating

struct GeneratorTests  {

    private static let arguments: [MockType] = [
        .dummy,
        .partial,
        .spy,
        .stub
    ]

    @Test(arguments: arguments)
    func multipleProtocols(type: MockType) async throws {
        try await runTest(template: MultipleProtocolTemplate(), for: type)
    }

    @Test(arguments: arguments)
    func diamondInheritanceProtocols(type: MockType) async throws {
        try await runTest(template: DiamondInheritanceTemplate(), for: type)
    }

    @Test(arguments: arguments)
    func multipleOverloadingProtocols(type: MockType) async throws {
        try await runTest(template: MultipleOverloadingProtocolsTemplate(), for: type)
    }

    @Test(arguments: arguments)
    func testRemovesDuplicatesFromOverriddenClasses(type: MockType) async throws {
        try await runTest(template: ClassOverridingTemplate(), for: type)
    }

    @Test(arguments: arguments)
    func mocksSuperclasses(type: MockType) async throws {
        try await runTest(template: SuperclassTemplate(), for: type)
    }

    @Test(arguments: arguments)
    func deepProtocolInheritance(type: MockType) async throws {
        try await runTest(template: DeepProtocolInheritanceTemplate(), for: type)
    }

    @Test(arguments: arguments)
    func augmentedClassSubscript(type: MockType) async throws {
        try await runTest(template: AugmentedClassSubscriptTemplate(), for: type)
    }

    private func runTest(template: GeneratorTestTemplate, for type: MockType) async throws {
        let view = try await MustacheMockView(type: type)
        let generator = Generator(view: view)
        template.build(generator: generator)
        generator.generate()
        let expected = try #require(template.getExpected(type: type))
        StringCompareTestHelper.expectEqualStrings(view.rendered, expected)
    }
}
