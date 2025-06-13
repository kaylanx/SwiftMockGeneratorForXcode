//
//  StringDecorator.swift
//  MockGenerating
//
//  Created by Andy Kayley on 13/06/2025.
//

protocol StringDecorating {
    var nextDecorator: StringDecorating? { get }

    func decorate(_ string: String) -> String
    func process(_ string: String) -> String
}

extension StringDecorating {
    func process(_ string: String) -> String {
        let decorated = decorate(string)
        return nextDecorator?.process(decorated) ?? decorated
    }
}
