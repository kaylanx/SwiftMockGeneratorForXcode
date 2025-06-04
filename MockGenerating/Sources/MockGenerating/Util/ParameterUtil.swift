//
//  ParameterUtil.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//


enum ParameterUtil {

    static func getParameterList(parameters: String) -> [String] {
        return parameters
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    static func getParameters(parameters: String) -> [Parameter] {
        return getParameterList(parameters: parameters)
            .compactMap { build(parameter: $0) }
    }

    private static func build(parameter: String) -> Parameter? {
        let components = getComponents(parameters: parameter)
        if components.isEmpty {
            return nil
        }
        let label = components[0]
        let name = components[1]
        let type = cleanType(type: components[2])
        return Parameter(
            externalName: label,
            internalName: name,
            type: ResolvedType(
                originalType: TypeIdentifier(identifier: type),
                resolvedType: TypeIdentifier(identifier: type)
            ),
            text: parameter,
            isEscaping: false
        )
    }

    private static func cleanType(type: String) -> String {
        let stripped = removeAnnotations(type: type)
        return removeDefaultArguments(type: stripped)
    }

    private static func getComponents(parameters: String) -> [String] {
        guard let typeIndex = parameters.firstIndex(of: ":") else {
            return []
        }

        let labelName = String(parameters[..<typeIndex])
        let type = String(parameters[parameters.index(after: typeIndex)...])  // May have more than 1 ':' if type is closure

        let components = replaceSpacesWithSpace(string: labelName).split(separator: " ").map { String($0) }
        guard let label = components.first, !label.isEmpty else {
            return []
        }

        let name = findName(components: components) ?? label
        return [label, name, type]
    }

    private static func replaceSpacesWithSpace(string: String) -> String {
        string.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }

    private static func findName(components: [String]) -> String? {
        if components.count > 1 && !components[1].isEmpty {
            return components[1]
        }
        return nil
    }

    private static func removeAnnotations(type: String) -> String {
        let removed = removeConventionAnnotation(type: type)
        return removeSimpleAnnotation(type: removed)
    }

    private static func removeDefaultArguments(type: String) -> String {
        return type.split(separator: "=").first?.trimmingCharacters(in: .whitespaces) ?? type
    }

    private static func removeConventionAnnotation(type: String) -> String {
        return type.replacingOccurrences(
            of: #"@convention\s*\([\w\s]+\)"#,
            with: "",
            options: .regularExpression
        )
    }

    private static func removeSimpleAnnotation(type: String) -> String {
        return type.replacingOccurrences(
            of: #"@[A-Za-z]+"#,
            with: "",
            options: .regularExpression
        )
    }
}
