//
//  Generator.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

public class Generator {
    private let view: MockView
    private var mockClass: MockClass?
    private var classes: [Class] = []
    private var protocols: [`Protocol`] = []

    public init(view: MockView) {
        self.view = view
    }

    public func set(class: MockClass) {
        mockClass = `class`
        var superclass = `class`.inheritedClass
        while let current = superclass {
            classes.append(current)
            superclass = current.inheritedClass
        }
        add(protocols: `class`.protocols)
    }

    private func add(protocols: [`Protocol`]) {
        protocols.forEach { self.protocols.append($0) }
        protocols.forEach { add(protocols: $0.protocols) }
    }

    @discardableResult
    public func generate() -> String {
        let presenter = MockViewPresenter(view: view)
        setScope(for: presenter)
        presenter.set(classInitializers: getClassInitializersRemovingDuplicates())
        presenter.add(classProperties: getClassPropertiesRemovingDuplicates())
        presenter.add(classMethods: getClassMethodsRemovingDuplicates())
        presenter.add(classSubscripts: getClassSubscriptsRemovingDuplicates())
        presenter.add(initializers: getInitializersRemovingDuplicates())
        presenter.add(properties: getPropertiesRemovingDuplicates())
        presenter.add(methods: getMethodsRemovingDuplicates())
        presenter.add(subscripts: getSubscriptsRemovingDuplicates())
        return presenter.generate()
    }

    private func setScope(for presenter: MockViewPresenter) {
        if let scope = mockClass?.scope {
            presenter.set(scope: scope)
        }
    }

    private func getClassInitializersRemovingDuplicates() -> [Initializer] {
        return classes.flatMap { $0.initializers }
    }

    private func getClassPropertiesRemovingDuplicates() -> [Property] {
        []
//        return Array(Set(
//            classes.flatMap { $0.properties }.map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            classes.flatMap { $0.properties }.first { SignatureGenerator.signature($0) == signature }
//        }
    }

    private func getClassMethodsRemovingDuplicates() -> [Method] {
        []
//        return Array(Set(
//            classes.flatMap { $0.methods }.map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            classes.flatMap { $0.methods }.first { SignatureGenerator.signature($0) == signature }
//        }
    }

    private func getClassSubscriptsRemovingDuplicates() -> [Subscript] {
        []
//        return Array(Set(
//            classes.flatMap { $0.subscripts }.map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            classes.flatMap { $0.subscripts }.first { SignatureGenerator.signature($0) == signature }
//        }
    }

    private func getInitializersRemovingDuplicates() -> [Initializer] {
        []
//        return Array(Set(
//            protocols.flatMap { $0.initializers }.map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            protocols.flatMap { $0.initializers }.first { SignatureGenerator.signature($0) == signature }
//        }
    }

    private func getPropertiesRemovingDuplicates() -> [Property] {
        []
//        let classSignatures = Set(classes.flatMap { $0.properties }.map { SignatureGenerator.signature($0) })
//        return Array(Set(
//            protocols.flatMap { $0.properties }
//                .filter { !classSignatures.contains(SignatureGenerator.signature($0)) }
//                .map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            protocols.flatMap { $0.properties }.first { SignatureGenerator.signature($0) == signature }
//        }
    }

    private func getMethodsRemovingDuplicates() -> [Method] {
        []
//        let classSignatures = Set(classes.flatMap { $0.methods }.map { SignatureGenerator.signature($0) })
//        return Array(Set(
//            protocols.flatMap { $0.methods }
//                .filter { !classSignatures.contains(SignatureGenerator.signature($0)) }
//                .map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            protocols.flatMap { $0.methods }.first { SignatureGenerator.signature($0) == signature }
//        }
    }

    private func getSubscriptsRemovingDuplicates() -> [Subscript] {
        []
//        let classSignatures = Set(classes.flatMap { $0.subscripts }.map { SignatureGenerator.signature($0) })
//        return Array(Set(
//            protocols.flatMap { $0.subscripts }
//                .filter { !classSignatures.contains(SignatureGenerator.signature($0)) }
//                .map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            protocols.flatMap { $0.subscripts }.first { SignatureGenerator.signature($0) == signature }
//        }
    }
}
