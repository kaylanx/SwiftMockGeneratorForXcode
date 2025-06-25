//
//  CreateInvokedParametersTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 14/06/2025.
//

import Testing
@testable import MockGenerating

struct CreateInvokedParametersTests {

    @Test
    func shouldReturnNil_whenNoParameters() {
        #expect(transformParameters(parameters: "") == nil)
    }

    @Test
    func shouldReturnNil_whenOnlyWhitespace() {
        #expect(transformParameters(parameters: "     \n  \t   ") == nil)
    }

    @Test
    func shouldReturnTupleWithVoid_whenOneParameter() {
        let parameters = [
            TupleParameter(name: "param1", type: "Int"),
            TupleParameter(name: "", type: "Void")
        ]
        assertTuple(
            expectedType: "(param1: Int, Void)",
            expectedParameters: parameters,
            methodParameters: "param1: Int"
        )
    }

    @Test
    func shouldReturnTuple_whenTwoParameters() {
        let parameters = [
            TupleParameter(name: "param1", type: "Int"),
            TupleParameter(name: "param2", type: "String")
        ]
        assertTuple(
            expectedType: "(param1: Int, param2: String)",
            expectedParameters: parameters,
            methodParameters: "param1: Int, param2: String"
        )
    }

    @Test
    func shouldReturnTuple_whenMoreThanTwoParameters() {
        let parameters = [
            TupleParameter(name: "param1", type: "Int"),
            TupleParameter(name: "param2", type: "String"),
            TupleParameter(name: "param3", type: "UInt")
        ]
        assertTuple(
            expectedType: "(param1: Int, param2: String, param3: UInt)",
            expectedParameters: parameters,
            methodParameters: "param1: Int, param2: String, param3: UInt"
        )
    }

    @Test
    func shouldReturnUseParameterName_whenParameterLabelIsPresent() {
        let parameters = [
            TupleParameter(name: "name1", type: "Int"),
            TupleParameter(name: "", type: "Void")
        ]
        assertTuple(
            expectedType: "(name1: Int, Void)",
            expectedParameters: parameters,
            methodParameters: "label1 name1: Int"
        )
    }

    @Test
    func shouldReturnUseParameterNames_whenParameterLabelsArePresent() {
        let parameters = [
            TupleParameter(name: "name1", type: "Int"),
            TupleParameter(name: "name2", type: "String")
        ]
        assertTuple(
            expectedType: "(name1: Int, name2: String)",
            expectedParameters: parameters,
            methodParameters: "label1 name1: Int, label2 name2: String"
        )
    }

    @Test
    func shouldHandleWhitespace() {
        let parameters = [
            TupleParameter(name: "name1", type: "Int"),
            TupleParameter(name: "name2", type: "String")
        ]
        assertTuple(
            expectedType: "(name1: Int, name2: String)",
            expectedParameters: parameters,
            methodParameters: "  label1  name1 : Int ,  label2  name2 : String "
        )
    }

    @Test
    func shouldHandleNewlines() {
        let methodParameters = """
        label1
        name1
        :
        Int
        ,
        label2  name2
        : String
        """
        let parameters = [
            TupleParameter(name: "name1", type: "Int"),
            TupleParameter(name: "name2", type: "String")
        ]
        assertTuple(
            expectedType: "(name1: Int, name2: String)",
            expectedParameters: parameters,
            methodParameters: methodParameters
        )
    }

    @Test
    func shouldHandleTabs() {
        #expect(transformParameters(parameters: "closure: () -> ()") == nil)
    }

    @Test
    func shouldIgnoreClosureOnlyParameter() {
        let parameters = [
            TupleParameter(name: "param2", type: "String"),
            TupleParameter(name: "", type: "Void")
        ]
        assertTuple(
            expectedType: "(param2: String, Void)",
            expectedParameters: parameters,
            methodParameters: "param1: (arg: String) -> Void, param2: String"
        )
    }

    @Test
    func shouldIgnoreClosureParameter() {
        let parameters = [
            TupleParameter(name: "param2", type: "String"),
            TupleParameter(name: "", type: "Void")
        ]
        assertTuple(
            expectedType: "(param2: String, Void)",
            expectedParameters: parameters,
            methodParameters: "param1: (arg: String) -> Void, param2: String"
        )
    }

    @Test
    func shouldIgnoreClosureTypealiasParameter() {
        let tuple = transformParameters(
            parameters: Parameter.Builder(externalName: "param", internalName: "name")
                .type("Completion")
                .resolvedType().function { _ in }
                .build()
        )
        #expect(tuple == nil)
    }

    @Test
    func shouldReplaceIUOWithOptional() {
        let parameters = [
            TupleParameter(name: "param0", type: "String?"),
            TupleParameter(name: "", type: "Void")
        ]
        assertTuple(
            expectedType: "(param0: String?, Void)",
            expectedParameters: parameters,
            methodParameters: "param0: String!"
        )
    }

    @Test
    func shouldRemoveInOut() {
        let parameters = [
            TupleParameter(name: "param0", type: "Int"),
            TupleParameter(name: "inout", type: "Int")
        ]
        assertTuple(
            expectedType: "(param0: Int, inout: Int)",
            expectedParameters: parameters,
            methodParameters: "param0: inout Int, inout: Int"
        )
    }

    @Test
    func shouldReplaceEmptyTupleWithVoid() {
        let parameters = [
            TupleParameter(name: "param0", type: "Void"),
            TupleParameter(name: "", type: "Void")
        ]
        assertTuple(
            expectedType: "(param0: Void, Void)",
            expectedParameters: parameters,
            methodParameters: "param0: ()"
        )
    }

    private func transformParameters(parameters: String) -> TuplePropertyDeclaration? {
        CreateInvokedParameters()
            .transform(
                parameterList: ParameterUtil.getParameters(
                    parameters: parameters
                ),
                genericIdentifiers: []
            )
    }

    private func transformParameters(parameters: Parameter...) -> TuplePropertyDeclaration? {
        CreateInvokedParameters().transform(
            parameterList: parameters,
            genericIdentifiers: []
        )
    }

    private func assertTuple(
        expectedType: String,
        expectedParameters: [TupleParameter],
        methodParameters: String
    ) {
        let property = transformParameters(parameters: methodParameters)
        #expect(expectedParameters.map { $0.type } == property?.parameters.map { $0.type })
        #expect(expectedParameters.map { $0.name } == property?.parameters.map { $0.name })
        #expect(expectedType == property?.text)
    }

    private func assertTuple(
        expectedType: String,
        expectedParameters: [TupleParameter],
        parameters: [Parameter]
    ) {
        let property = CreateInvokedParameters().transform(
            parameterList: parameters,
            genericIdentifiers: []
        )
        #expect(expectedParameters.map { $0.type } == property?.parameters.map { $0.type })
        #expect(expectedParameters.map { $0.name } == property?.parameters.map { $0.name })
        #expect(expectedType == property?.text)
    }
}
