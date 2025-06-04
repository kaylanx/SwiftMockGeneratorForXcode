//
//  MethodModel.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

class MethodModel {

    internal struct NameTypeTuple {
        let name: String
        let type: String
    }

    private let methodName: String

    private let namesAndTypes: [NameTypeTuple]
    private var index = -2

    var id: String {
        var id = methodName + "("
        id += namesAndTypes.map { nameAndType in nameAndType.name + ":" + nameAndType.type }
            .joined(separator: ",")
        id += ")"
        return id
    }

    var parameterCount: Int {
        namesAndTypes.count
    }

    private var filteredNames: [String] {
       namesAndTypes
            .map { $0.name }
            .filter { isNameValid(name: $0) }
    }

    private var filteredTypes: [String] {
        namesAndTypes
            .map { $0.type }
            .filter { isTypeValid(type: $0) }
    }

    init(methodName: String, paramLabels: [Parameter]) {
        self.methodName = methodName
        self.namesAndTypes = paramLabels.map { param in
            var label = param.externalName ?? param.internalName
            if label.isEmpty {
                label = param.internalName
            }
            let type = param.originalTypeText.replacingOccurrences(of: "\\W", with: "", options: .regularExpression)
            return NameTypeTuple(name: label, type: type)
        }
    }

    convenience init(methodName: String, paramLabels: String...) {
        let params = ParameterUtil.getParameters(parameters: paramLabels.joined(separator: ", "))
        self.init(methodName: methodName, paramLabels: params)
    }

    func nextPreferredName() -> String? {
        if !hasNextPreferredName() {
            return nil
        }
        index += 1
        return getPreferredNameAt(index: index)
    }

    private func hasNextPreferredName() -> Bool {
        return index + 1 < filteredNames.count + filteredTypes.count
    }

    private func getPreferredNameAt(index: Int) -> String {
        var name = methodName
        let names = filteredNames
        let types = filteredTypes
        let nameCount = min(index + 1, names.count)
        let typeCount = min(index + 1 - nameCount, types.count)
        var nameIndex = 0
        var typeIndex = 0
        for nameAndType in namesAndTypes {
            if nameIndex < nameCount && isNameValid(name: nameAndType.name) {
                nameIndex += 1
                name.append(nameAndType.name.capitalizingFirstLetter())
            }
            if typeIndex < typeCount && isTypeValid(type: nameAndType.type) {
                typeIndex += 1
                name.append(nameAndType.type.capitalizingFirstLetter())
            }
        }
        return name
    }

    func peekNextPreferredName() -> String? {
        guard hasNextPreferredName() else {
            return nil
        }
        return getPreferredNameAt(index: index + 1)
    }

    private func isNameValid(name: String) -> Bool {
        return !name.isEmpty && name != "_"
    }

    private func isTypeValid(type: String) -> Bool {
        return !type.isEmpty
    }
}

extension MethodModel: Hashable {
    static func == (lhs: MethodModel, rhs: MethodModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

fileprivate extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
