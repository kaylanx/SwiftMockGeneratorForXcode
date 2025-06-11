//
//  MustacheMockView.swift
//  MockGenerating
//
//  Created by Andy Kayley on 06/06/2025.
//
import Foundation
import Mustache
@testable import MockGenerating

final class MustacheMockView: MockView {

    private let type: MockViewType
    private var library: MustacheLibrary!
    var rendered: String? = ""

    init(type: MockViewType) async throws {
        self.type = type

        guard let templatesDirectory = Bundle.module.url(forResource: "Templates", withExtension: nil) else {
            fatalError("Couldn't find templates directory")
        }
        let templateDirPath = templatesDirectory.path()
        library = try await MustacheLibrary(directory: templateDirPath)
    }

    func render(model: MockViewModel) {
        let rendered = library.render(model, withTemplate: "\(type)")

        let lines = rendered?.components(separatedBy: "\n")
        self.rendered = lines?
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
    }
}

enum MockViewType: String {
    case dummy

    var directoryName: String { rawValue.capitalized }
}
