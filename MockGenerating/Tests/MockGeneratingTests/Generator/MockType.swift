//
//  MockType.swift
//  MockGenerating
//
//  Created by Andy Kayley on 17/06/2025.
//

enum MockType: String {
    case dummy
    case partial
    case spy
    case stub

    var directoryName: String { rawValue.capitalized }
}
