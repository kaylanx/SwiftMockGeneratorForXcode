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
//
//    @Test
//    fun testDiamondInheritanceProtocols() {
//        runTest(DiamondInheritanceTest())
//    }
//
//    @Test
//    fun testMultipleOverloadingProtocols() {
//        runTest(MultipleOverloadingProtocolsTest())
//    }
//
//    @Test
//    fun testRemovesDuplicatesFromOverriddenClasses() {
//        runTest(ClassOverridingTest())
//    }
//
//    @Test
//    fun testMocksSuperclasses() {
//        runTest(SuperclassTest())
//    }
//
//    @Test
//    fun testDeepProtocolInheritance() {
//        runTest(DeepProtocolInheritanceTest())
//    }
//
//    fun testAugmentedClassSubscript() {
//        runTest(AugmentedClassSubscriptTest())
//    }
//
    private func runTest(template: GeneratorTestTemplate, for type: MockType) async throws {
        let view = try await MustacheMockView(type: type)
        let generator = Generator(view: view)
        template.build(generator: generator)
        generator.generate()
        let expected = try #require(template.getExpected(type: type))
        StringCompareTestHelper.expectEqualStrings(view.rendered, expected)
    }
}
