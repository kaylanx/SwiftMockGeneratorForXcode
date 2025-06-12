//
//  UniqueMethodNameGenerator.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

class UniqueMethodNameGenerator {
    private var uniqueMethodName = [String: String]()
    private var duplicateMethodModels: Set<MethodModel>

    init(methodModels: [MethodModel]) {
        self.duplicateMethodModels = Set(methodModels)
    }

    convenience init(methodModels: MethodModel...) {
        self.init(methodModels: methodModels)
    }

    func generateMethodNames() {
        while !duplicateMethodModels.isEmpty {
            processDuplicates()
        }
    }

    private func processDuplicates() {
        let nameBuckets = moveDuplicatesToNameBuckets()
        for (name, models) in nameBuckets {
            commitUniqueModels(name: name, models: models)
        }
    }

    private func commitUniqueModels(name: String, models: [MethodModel]) {
        if models.count == 1 {
            commitModel(name: name, model: models[0])
            return
        }

        var sortedModels = models
        sortBySimplest(&sortedModels)

        guard let simplestModel = sortedModels.first else { return }

        if isUniquelySimple(sortedModels) {
            commitModel(name: name, model: simplestModel)
        }

        commitModelsThatCannotGetMoreComplex(models: sortedModels, name: name)
    }

    private func commitModelsThatCannotGetMoreComplex(models: [MethodModel], name: String) {
        models
            .filter { canModelGetMoreComplex($0) }
            .forEach { commitModel(name: name, model: $0) }
    }

    private func canModelGetMoreComplex(_ model: MethodModel) -> Bool {
        return model.peekNextPreferredName() == nil
    }

    private func isUniquelySimple(_ models: [MethodModel]) -> Bool {
        guard models.count > 1 else { return true }
        let simplestParamCount = models[0].parameterCount
        let nextSimplestParamCount = models[1].parameterCount
        return simplestParamCount < nextSimplestParamCount
    }

    private func commitModel(name: String, model: MethodModel) {
        duplicateMethodModels.remove(model)
        uniqueMethodName[model.id] = strip(name)
    }

    private func strip(_ name: String) -> String {
        let pattern = "\\W"
        return name.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
    }

    private func sortBySimplest(_ models: inout [MethodModel]) {
        models.sort { $0.parameterCount < $1.parameterCount }
    }

    private func moveDuplicatesToNameBuckets() -> [String: [MethodModel]] {
        var nameBuckets: [String: [MethodModel]] = [:]
        for model in duplicateMethodModels {
            if let name = model.nextPreferredName() {
                nameBuckets[name, default: []].append(model)
            }
        }
        return nameBuckets
    }

    func getMethodName(id: String) -> String? {
        return uniqueMethodName[id]
    }
}
