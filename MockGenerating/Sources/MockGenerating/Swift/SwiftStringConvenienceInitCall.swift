//
//  SwiftStringConvenienceInitCall.swift
//  MockGenerating
//
//  Created by Andy Kayley on 03/06/2025.
//

final class SwiftStringConvenienceInitCall {

    let store = DefaultValueStore()

    func transform(call: InitialiserCall) -> String {
        if call.parameters.isEmpty && call.isFailable {
            return "super.init()!"
        }
        let forceUnwrap = getForceUnwrap(call: call)
        let forceTry = getForceTry(call: call)
        let `await` = getAwait(call: call)
        let parameters = transformParameters(call: call).joined(separator: ", ")
        return "\(forceTry)\(`await`)self.init(\(parameters))\(forceUnwrap)"
    }

    private func getForceUnwrap(call: InitialiserCall) -> String {
        call.isFailable ? "!" : ""
    }
        
    private func getForceTry(call: InitialiserCall) -> String {
        call.throws ? "try! " : ""
    }

    private func getAwait(call: InitialiserCall) -> String {
        call.async ? "await " : ""
    }

    private func transformParameters(call: InitialiserCall) -> [String] {
        call.parameters.map {
            let value = getValue(
                label: $0.externalName ?? $0.internalName,
                type: $0.originalTypeText
            )
            return if $0.externalName == "_" {
                value
            } else if $0.externalName == nil || $0.externalName?.isEmpty == true {
                $0.internalName + ": " + value
            } else {
                $0.externalName! + ": " + value
            }
        }
    }

    private func getValue(label: String, type: String) -> String {
        if let value = store.getDefaultValue(for: type) {
            return value
        } else if OptionalUtil.isOptional(type: type) {
            return "nil"
        } else {
            return "<\u{23}\(label)\u{23}>"
        }
    }
}
