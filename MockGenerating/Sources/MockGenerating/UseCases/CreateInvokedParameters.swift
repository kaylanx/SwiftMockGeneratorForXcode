//
//  CreateInvokedParameters.swift
//  MockGenerating
//
//  Created by Andy Kayley on 13/06/2025.
//

final class CreateInvokedParameters {
    func getStringDecorator() -> StringDecorating {
        let invoked = PrependStringDecorator(prefix: "invoked")
        return AppendStringDecorator(
            nextDecorator: invoked,
            suffix: "Parameters"
        )
    }

    func transform(parameterList: [Parameter],
                  genericIdentifiers: [String]) -> TuplePropertyDeclaration? {
        let tupleParameters = parameterList
            .compactMap {
                transformParameter(
                    parameter: $0,
                    genericIdentifiers: genericIdentifiers
                )
            }
        if validateParameters(parameterList: parameterList, tupleParameters: tupleParameters) {
            return createProperty(tupleParameters: tupleParameters.filter { !isClosure(parameter: $0) })
        }
        return nil
    }

    private func transformName(name: String) -> String {
        return getStringDecorator().process(name)
    }

    private func validateParameters(parameterList: [Any], tupleParameters: [Any]) -> Bool {
        parameterList.count == tupleParameters.count
    }

    private func createProperty(tupleParameters: [TupleParameter]) -> TuplePropertyDeclaration? {
        guard tupleParameters.isEmpty == false else {
            return nil
        }

        guard tupleParameters.count > 1 else {
            return TuplePropertyDeclaration(parameters: tupleParameters)
        }

        var mutable = tupleParameters
        mutable.append(TupleParameter(name: "", type: "Void"))
        return TuplePropertyDeclaration(parameters: mutable)
    }

    private func isClosure(parameter: TupleParameter) -> Bool {
        return ClosureUtil.isClosure(type: parameter.resolvedType)
    }

    private func transformParameter(parameter: Parameter, genericIdentifiers: [String]) -> TupleParameter? {
        let name = parameter.internalName
        let copied = CopyVisitor.copy(parameter.type.originalType)
        TypeErasingVisitor.erase(type: copied, genericIdentifiers: genericIdentifiers)
        let resolvedType = parameter.resolvedTypeText
        return TupleParameter(
            name: name,
            type: replaceEmptyTuple(
                type: removeInOut(
                    from: replaceIUO(
                        type: copied.text
                    )
                )
            ),
            resolvedType: resolvedType
        )
    }

    private func replaceIUO(type: String) -> String {

        guard type.hasSuffix("!") else {
            return type
        }

        return type.dropLast(1).appending("?")
    }

    private func replaceEmptyTuple(type: String) -> String {
        guard type == "()" else {
            return type
        }

        return "Void"
    }

    private func removeInOut(from type: String) -> String {
        let prefix = "inout "
        guard let range = type.range(of: prefix) else {
            return type
        }
        return String(type[range.upperBound...])
    }
}
