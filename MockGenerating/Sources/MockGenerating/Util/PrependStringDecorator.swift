//
//  PrependStringDecorator.swift
//  MockGenerating
//
//  Created by Andy Kayley on 13/06/2025.
//

struct PrependStringDecorator: StringDecorating {
    let nextDecorator: StringDecorating? = nil
    let prefix: String

    func decorate(_ string: String) -> String {
        guard string.isEmpty == false else {
            return ""
        }

        guard prefix.isEmpty == false else {
            return string
        }

        let capitalized = string.capitalizingFirstLetter()
        return prefix + capitalized
    }
}
