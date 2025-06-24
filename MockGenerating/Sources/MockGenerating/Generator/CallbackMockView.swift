//
//  CallbackMockView.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

public final class CallbackMockView: MockView {
    private let callback: (MockViewModel) -> String

    public init(callback: @escaping (MockViewModel) -> String) {
        self.callback = callback
    }

    public private(set) var result = [String]()

    public func render(model: MockViewModel) {
        result = callback(model)
            .split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { $0.isEmpty == false }
    }
}
