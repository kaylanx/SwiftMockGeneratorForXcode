//
//  UniqueMethodNameGeneratorTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 11/06/2025.
//

import Testing
@testable import MockGenerating

struct UniqueMethodNameGeneratorTests  {

    private var generator: UniqueMethodNameGenerator!

    @Test("Unique Method Name Should Return Method Name")
    mutating func uniqueMethodNameShouldReturnMethodName() {
        assertEquals(
            models: [
                MethodModel(
                    methodName: "methodName"
                )
            ],
            expected: ["methodName"]
        )
    }

    @Test("Should Return Nil When ID Does Not Exist")
    mutating func shouldReturnNilWhenIDDoesNotExist() {
        generator = createGenerator()
        #expect(generator.getMethodName(id: "1") == nil)
    }

    @Test("When No Overloaded Methods Then Unique Method Name Should Return Method Name")
    mutating func whenNoOverloadedMethodsUniqueMethodNameShouldReturnMethodName() {
        assertEquals(
            models: [
                MethodModel(
                    methodName: "methodName",
                    paramLabels: "param",
                    "param2"
                )
            ],
            expected: [
                "methodName" // should not add labels when method name is unique
            ]
        )
    }

    @Test("Duplicate Method Name Should Append First Parameter Label To Method Name")
    mutating func duplicateMethodNameShouldAppendFirstParameterLabelToMethodName() {
        assertEquals(
            models: [
                MethodModel(methodName: "methodName"),
                MethodModel(methodName: "anotherMethod"),
                MethodModel(methodName: "methodName", paramLabels: "param: Type")
            ],
            expected: [
                "methodName",
                "anotherMethod",
                // should add label when method name is overloaded
                // should not use type when label is unique
                "methodNameParam"
            ]
        )
    }

    @Test("Duplicate Method Name Should Append First Parameter Label To Method Name When Given Method Has Multiple Param Labels")
    mutating func duplicateMethodNameShouldAppendFirstParameterLabelToMethodNameWhenGivenMethodHasMultipleParamLabels() {
        assertEquals(
            models: [
                MethodModel(methodName: "animate"),
                MethodModel(methodName: "animate", paramLabels: "withDuration duration: Type"),
                MethodModel(methodName: "animate", paramLabels: "withDuration duration: Type", "delay: Type"),
                MethodModel(methodName: "animate", paramLabels: "withDuration duration: Type", "delay: Type", "easing: Ease")
            ],
            expected: [
                "animate",
                // should not add anything when there is nothing to add
                "animateWithDuration",
                // should only use label unless all other labels are identical
                "animateWithDurationDelay",
                // should only use labels when last label is unique
                "animateWithDurationDelayEasing"
            ]
        )
    }

    @Test("Duplicate Method Name Should Use Types When Labels Match")
    mutating func duplicateMethodNameShouldUseTypesWhenLabelsMatch() {
        assertEquals(
            models: [
                MethodModel(methodName: "setValue", paramLabels: "_ value: String"),
                MethodModel(methodName: "setValue", paramLabels: "_ value: Int"),
                MethodModel(methodName: "set", paramLabels: "object: String", "forKey key: String"),
                MethodModel(methodName: "set", paramLabels: "object: Int", "forKey key: String"),
                MethodModel(methodName: "setNumber", paramLabels: "_ number: Float", "at index: Int"),
                MethodModel(methodName: "setNumber", paramLabels: "_ number: Int", "forKey key: String"),
                MethodModel(methodName: "setMultiple", paramLabels: "_ number: Int", "for key: Int"),
                MethodModel(methodName: "setMultiple", paramLabels: "_ number: Int", "for key: String")
            ],
            expected: [
                // should use type when method name and parameters are overloaded
                "setValueString",
                "setValueInt",
                "setObjectStringForKey",
                "setObjectIntForKey",
                "setNumberAt",
                "setNumberForKey",
                "setMultipleIntForInt",
                "setMultipleIntForString"
            ]
        )
    }

    @Test("Duplicate Method Name Should Use Types When Labels Match And NextParamsMatch")
    mutating func duplicateMethodNameShouldUseTypesWhenLabelsMatchAndNextParamsMatch() {
        assertEquals(
            models: [
                MethodModel(methodName: "setValue", paramLabels: "_ value: String"),
                MethodModel(methodName: "setValue", paramLabels: "_ value: Int"),
                MethodModel(methodName: "setValue", paramLabels: "_ value: String", "forKey key: String"),
                MethodModel(methodName: "setValue", paramLabels: "_ value: Int", "forKey key: String")
            ],
            expected: [
                // should use type when labels match and there is another identical method except its type
                "setValueString",
                "setValueInt",
                "setValueStringForKey",
                "setValueIntForKey"
            ]
        )
    }

    @Test("Should Ignore Default Arguments")
    mutating func shouldIgnoreDefaultArguments() {
        assertEquals(
            models: [
                MethodModel(methodName: "method", paramLabels: "param: String = \"\""),
                MethodModel(methodName: "method", paramLabels: "param: Int = 345")
            ],
            expected: [
                "methodParamString",
                "methodParamInt"
            ]
        )
    }

    @Test("Should Process One Letter Method Names")
    mutating func shouldProcessOneLetterMethodNames() {
        assertEquals(
            models: [
                MethodModel(methodName: "a", paramLabels: ""),
                MethodModel(methodName: "a", paramLabels: "b: Type")
            ],
            expected: [
                "a",
                "aB"
            ]
        )
    }

    @Test("Should Allow Duplicate Methods")
    mutating func shouldAllowDuplicateMethods() {
        assertEquals(
            models: [
                MethodModel(methodName: "method"),
                MethodModel(methodName: "method")
            ],
            expected: [
                "method",
                "method"
            ]
        )
    }

    @Test("Should Process Stray Whitespace")
    mutating func shouldProcessStrangeWhitespace() {
        assertEquals(
            models: [
                MethodModel(methodName: "method", paramLabels: "    param1     :     String   ", " param3   label    : Int  "),
                MethodModel(methodName: "method", paramLabels: "param1:String", "param2:Int")
            ],
            expected: [
                "methodParam1Param3",
                "methodParam1Param2"
            ]
        )
    }

    @Test("Should Ignore Incomplete Parameters")
    mutating func shouldIgnoreIncompleteParameters() {
        assertEquals(
            models: [
                MethodModel(methodName: "method", paramLabels: "_"),
                MethodModel(methodName: "method", paramLabels: "param1"),
                MethodModel(methodName: "method", paramLabels: ":String"),
                MethodModel(methodName: "method", paramLabels: ":Int")
            ],
            expected: [
                "method",
                "method",
                "method",
                "method"
            ]
        )
    }

    @Test("Should Ignore Special Characters In Tuples And Closures")
    mutating func shouldIgnoreSpecialCharactersInTuplesAndClosures() {
        assertEquals(
            models: [
                MethodModel(methodName: "method", paramLabels: "_ tuple: (String, Int)"),
                MethodModel(methodName: "method", paramLabels: "_ tuple: (UInt, Float)"),
                MethodModel(methodName: "anotherMethod", paramLabels: "_ closure: (Int) -> ()"),
                MethodModel(methodName: "anotherMethod", paramLabels: "_ closure: () -> String ")
            ],
            expected: [
                "methodStringInt",
                "methodUIntFloat",
                "anotherMethodInt",
                "anotherMethodString"
            ]
        )
    }

    @discardableResult
    private mutating func createGenerator(models: [MethodModel] = []) -> UniqueMethodNameGenerator {
        generator = UniqueMethodNameGenerator(methodModels: models)
        generator.generateMethodNames()
        return generator
    }

    private mutating func assertEquals(models: [MethodModel], expected: [String]) {
        createGenerator(models: models)
        models.enumerated().forEach { index, model in
            let id = generator.getMethodName(id: model.id)
            #expect(expected[index] == id)
        }
    }
}
