//
//  FunctionParameterTransformer.swift
//  MockGenerating
//
//  Created by Andy Kayley on 15/06/2025.
//

final class FunctionParameterTransformer: RecursiveVisitor {

    private var isOptional = false
    private let name: String
    var transformed: ClosureParameterViewModel? = nil

    init(name: String) {
        self.name = name
    }

    override func visit(functionType type: FunctionType) {
        transformed = ClosureParameterViewModel(
            capitalizedName: name.capitalizingFirstLetter(),
            name: name,
            argumentsTupleRepresentation: transformClosureToTupleDeclaration(parameters: type.arguments),
            implicitClosureCall: transformClosureToImplicitTupleAssignment(function: type),
            hasArguments: !type.arguments.isEmpty
        )
        super.visit(functionType: type)
    }

    override func visit(optionalType type: OptionalType) {
        isOptional = true
        super.visit(optionalType: type)
    }

    private func transformClosureToTupleDeclaration(parameters: [`Type`]) -> String {
        return if parameters.isEmpty {
            "()"
        } else if parameters.count == 1 {
            "(\(parameters[0].text), Void)"
        } else {
            "(\(joinParameters(parameters: parameters)))"
        }
    }

    private func joinParameters(parameters: [`Type`]) -> String {
        return parameters.map(\.text).joined(separator: ", ")
    }

    private func transformClosureToImplicitTupleAssignment(function: FunctionType) -> String {
        var assignment = [String]()
        supressWarning(assignment: &assignment, function: function)
        tryNicely(assignment: &assignment, function: function)
        awaitIfNeeded(assignment: &assignment, function: function)
        call(assignment: &assignment)
        addParameters(assignment: &assignment, function: function)
        return assignment.joined(separator: "")
    }

    private func supressWarning(assignment: inout [String], function: FunctionType) {
        if !TypeIdentifiers.isVoid(function.returnType) {
            assignment.append("_ = ")
        }
    }

    private func tryNicely(assignment: inout [String], function: FunctionType) {
        if function.throws {
            assignment.append("try? ")
        }
    }

    private func awaitIfNeeded(assignment: inout [String], function: FunctionType) {
        if function.async {
            assignment.append("await ")
        }
    }

    private func call(assignment: inout [String]) {
        assignment.append(name)
        if isOptional {
            assignment.append("?")
        }
    }

    private func addParameters(assignment: inout [String], function: FunctionType) {
        assignment.append("(")
        assignment.append(listParameters(function: function))
        assignment.append(")")
    }

    private func listParameters(function: FunctionType) -> String {
        (0..<function.arguments.count)
            .map { "result.\($0)" }
            .joined(separator: ", ")
    }
}
