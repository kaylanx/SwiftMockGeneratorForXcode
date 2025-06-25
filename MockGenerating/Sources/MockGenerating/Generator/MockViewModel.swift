//
//  MockViewModel.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

public struct MockViewModel {
    public let initializer: [InitializerViewModel]
    public let property: [PropertyViewModel]
    public let method: [MethodViewModel]
    public let `subscript`: [SubscriptViewModel]
    public let scope: String?

    public init(
        initializer: [InitializerViewModel],
        property: [PropertyViewModel],
        method: [MethodViewModel],
        `subscript`: [SubscriptViewModel],
        scope: String?
    ) {
        self.initializer = initializer
        self.property = property
        self.method = method
        self.`subscript` = `subscript`
        self.scope = scope
    }
}

public struct PropertyViewModel {
    public let name: String
    public let capitalizedUniqueName: String
    public let hasSetter: Bool
    public let type: String
    public let optionalType: String
    public let iuoType: String
    public let defaultValueAssignment: String
    public let defaultValue: String?
    public let isImplemented: Bool
    public let declarationText: String

    public init(
        name: String,
        capitalizedUniqueName: String,
        hasSetter: Bool,
        type: String,
        optionalType: String,
        iuoType: String,
        defaultValueAssignment: String,
        defaultValue: String?,
        isImplemented: Bool,
        declarationText: String
    ) {
        self.name = name
        self.capitalizedUniqueName = capitalizedUniqueName
        self.hasSetter = hasSetter
        self.type = type
        self.optionalType = optionalType
        self.iuoType = iuoType
        self.defaultValueAssignment = defaultValueAssignment
        self.defaultValue = defaultValue
        self.isImplemented = isImplemented
        self.declarationText = declarationText
    }
}

public struct MethodViewModel {
    public let capitalizedUniqueName: String
    public let escapingParameters: ParametersViewModel?
    public let closureParameter: [ClosureParameterViewModel]
    public let resultType: ResultTypeViewModel?
    public let functionCall: String?
    public let `async`: Bool
    public let `throws`: Bool
    public let `rethrows`: Bool
    public let isImplemented: Bool
    public let declarationText: String

    public init(
        capitalizedUniqueName: String,
        escapingParameters: ParametersViewModel?,
        closureParameter: [ClosureParameterViewModel],
        resultType: ResultTypeViewModel?,
        functionCall: String?,
        `async`: Bool,
        `throws`: Bool,
        `rethrows`: Bool,
        isImplemented: Bool,
        declarationText: String
    ) {
        self.capitalizedUniqueName = capitalizedUniqueName
        self.escapingParameters = escapingParameters
        self.closureParameter = closureParameter
        self.resultType = resultType
        self.functionCall = functionCall
        self.`async` = `async`
        self.`throws` = `throws`
        self.`rethrows` = `rethrows`
        self.isImplemented = isImplemented
        self.declarationText = declarationText
    }
}

public struct ResultTypeViewModel {
    public let defaultValueAssignment: String
    public let defaultValue: String?
    public let optionalType: String
    public let iuoType: String
    public let type: String
    public let returnCastStatement: String

    public init(
        defaultValueAssignment: String,
        defaultValue: String?,
        optionalType: String,
        iuoType: String,
        type: String,
        returnCastStatement: String
    ) {
        self.defaultValueAssignment = defaultValueAssignment
        self.defaultValue = defaultValue
        self.optionalType = optionalType
        self.iuoType = iuoType
        self.type = type
        self.returnCastStatement = returnCastStatement
    }
}

public struct ParametersViewModel {
    public let tupleRepresentation: String
    public let tupleAssignment: String

    public init(
        tupleRepresentation: String,
        tupleAssignment: String
    ) {
        self.tupleRepresentation = tupleRepresentation
        self.tupleAssignment = tupleAssignment
    }
}

public struct ClosureParameterViewModel {
    public var capitalizedName: String
    public var name: String
    public var argumentsTupleRepresentation: String
    public var implicitClosureCall: String
    public var hasArguments: Bool

    public init(
        capitalizedName: String,
        name: String,
        argumentsTupleRepresentation: String,
        implicitClosureCall: String,
        hasArguments: Bool
    ) {
        self.capitalizedName = capitalizedName
        self.name = name
        self.argumentsTupleRepresentation = argumentsTupleRepresentation
        self.implicitClosureCall = implicitClosureCall
        self.hasArguments = hasArguments
    }
}

public struct InitializerViewModel {
    public let declarationText: String
    public let initializerCall: String

    public init(
        declarationText: String,
        initializerCall: String
    ) {
        self.declarationText = declarationText
        self.initializerCall = initializerCall
    }
}

public struct SubscriptViewModel {
    public let capitalizedUniqueName: String
    public let escapingParameters: ParametersViewModel?
    public let hasSetter: Bool
    public let resultType: ResultTypeViewModel
    public let functionCall: String?
    public let isImplemented: Bool
    public let declarationText: String

    public init(
        capitalizedUniqueName: String,
        escapingParameters: ParametersViewModel?,
        hasSetter: Bool,
        resultType: ResultTypeViewModel,
        functionCall: String?,
        isImplemented: Bool,
        declarationText: String
    ) {
        self.capitalizedUniqueName = capitalizedUniqueName
        self.escapingParameters = escapingParameters
        self.hasSetter = hasSetter
        self.resultType = resultType
        self.functionCall = functionCall
        self.isImplemented = isImplemented
        self.declarationText = declarationText
    }
}
