////
////  Generator.swift
////  MockGenerating
////
////  Created by Andy Kayley on 02/06/2025.
////
//
//import Foundation
//
//class Generator {
//    private let view: MockView
//    private var mockClass: MockClass?
//    private var classes: [Class] = []
//    private var protocols: [`Protocol`] = []
//
//    init(view: MockView) {
//        self.view = view
//    }
//
//    func set(_ c: MockClass) {
//        mockClass = c
//        var superclass = c.inheritedClass
//        while let current = superclass {
//            classes.append(current)
//            superclass = current.inheritedClass
//        }
//        add(c.protocols)
//    }
//
//    private func add(_ protocols: [`Protocol`]) {
//        protocols.forEach { self.protocols.append($0) }
//        protocols.forEach { add($0.protocols) }
//    }
//
//    func generate() -> String {
//        let presenter = MockViewPresenter(view: view)
//        setScope(presenter)
//        presenter.setClassInitializers(getClassInitializersRemovingDuplicates())
//        presenter.addClassProperties(getClassPropertiesRemovingDuplicates())
//        presenter.addClassMethods(getClassMethodsRemovingDuplicates())
//        presenter.addClassSubscripts(getClassSubscriptsRemovingDuplicates())
//        presenter.addInitializers(getInitializersRemovingDuplicates())
//        presenter.addProperties(getPropertiesRemovingDuplicates())
//        presenter.addMethods(getMethodsRemovingDuplicates())
//        presenter.addSubscripts(getSubscriptsRemovingDuplicates())
//        return presenter.generate()
//    }
//
//    private func setScope(_ presenter: MockViewPresenter) {
//        if let scope = mockClass?.scope {
//            presenter.setScope(scope)
//        }
//    }
//
//    private func getClassInitializersRemovingDuplicates() -> [Initializer] {
//        return classes.flatMap { $0.initializers }
//    }
//
//    private func getClassPropertiesRemovingDuplicates() -> [Property] {
//        return Array(Set(
//            classes.flatMap { $0.properties }.map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            classes.flatMap { $0.properties }.first { SignatureGenerator.signature($0) == signature }
//        }
//    }
//
//    private func getClassMethodsRemovingDuplicates() -> [Method] {
//        return Array(Set(
//            classes.flatMap { $0.methods }.map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            classes.flatMap { $0.methods }.first { SignatureGenerator.signature($0) == signature }
//        }
//    }
//
//    private func getClassSubscriptsRemovingDuplicates() -> [Subscript] {
//        return Array(Set(
//            classes.flatMap { $0.subscripts }.map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            classes.flatMap { $0.subscripts }.first { SignatureGenerator.signature($0) == signature }
//        }
//    }
//
//    private func getInitializersRemovingDuplicates() -> [Initializer] {
//        return Array(Set(
//            protocols.flatMap { $0.initializers }.map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            protocols.flatMap { $0.initializers }.first { SignatureGenerator.signature($0) == signature }
//        }
//    }
//
//    private func getPropertiesRemovingDuplicates() -> [Property] {
//        let classSignatures = Set(classes.flatMap { $0.properties }.map { SignatureGenerator.signature($0) })
//        return Array(Set(
//            protocols.flatMap { $0.properties }
//                .filter { !classSignatures.contains(SignatureGenerator.signature($0)) }
//                .map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            protocols.flatMap { $0.properties }.first { SignatureGenerator.signature($0) == signature }
//        }
//    }
//
//    private func getMethodsRemovingDuplicates() -> [Method] {
//        let classSignatures = Set(classes.flatMap { $0.methods }.map { SignatureGenerator.signature($0) })
//        return Array(Set(
//            protocols.flatMap { $0.methods }
//                .filter { !classSignatures.contains(SignatureGenerator.signature($0)) }
//                .map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            protocols.flatMap { $0.methods }.first { SignatureGenerator.signature($0) == signature }
//        }
//    }
//
//    private func getSubscriptsRemovingDuplicates() -> [Subscript] {
//        let classSignatures = Set(classes.flatMap { $0.subscripts }.map { SignatureGenerator.signature($0) })
//        return Array(Set(
//            protocols.flatMap { $0.subscripts }
//                .filter { !classSignatures.contains(SignatureGenerator.signature($0)) }
//                .map { SignatureGenerator.signature($0) }
//        )).compactMap { signature in
//            protocols.flatMap { $0.subscripts }.first { SignatureGenerator.signature($0) == signature }
//        }
//    }
//}
