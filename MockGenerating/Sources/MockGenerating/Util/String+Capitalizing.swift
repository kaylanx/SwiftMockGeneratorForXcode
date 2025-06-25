//
//  String+Capitalizing.swift
//  MockGenerating
//
//  Created by Andy Kayley on 13/06/2025.
//

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
