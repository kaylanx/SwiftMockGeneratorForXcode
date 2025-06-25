//
//  ClosureUtil.swift
//  MockGenerating
//
//  Created by Andy Kayley on 13/06/2025.
//

enum ClosureUtil {
    static func isClosure(type: String) -> Bool {
        return type.contains("->")
    }

    static func surroundClosure(type: String) -> String {
        if !isClosure(type: type) || isClosureSurrounded(type: type) {
            return type
        }
        return "(\(type))"
    }

    private static func isClosureSurrounded(type: String) -> Bool {
        type.replacingOccurrences(of: " ", with: "").hasPrefix("((")
    }
}
