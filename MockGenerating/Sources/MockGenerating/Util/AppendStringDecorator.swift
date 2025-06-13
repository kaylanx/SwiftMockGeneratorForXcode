//
//  AppendStringDecorator.swift
//  MockGenerating
//
//  Created by Andy Kayley on 13/06/2025.
//

struct AppendStringDecorator: StringDecorating {
    let nextDecorator: StringDecorating?
    let suffix: String

    func decorate(_ string: String) -> String {
        guard string.isEmpty == false else {
            return ""
        }

        return suffix.isEmpty ? string : (string + suffix)
    }
}
