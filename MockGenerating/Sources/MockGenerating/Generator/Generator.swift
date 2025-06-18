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
        return classes.flatMap { $0.properties }
            .distinctBy { SignatureGenerator.signature(for: $0) }
    }

    private func getClassMethodsRemovingDuplicates() -> [Method] {
        return classes.flatMap { $0.methods }
            .distinctBy { SignatureGenerator.signature(for: $0) }
    }

    private func getClassSubscriptsRemovingDuplicates() -> [Subscript] {
        return classes.flatMap { $0.subscripts }
            .distinctBy { SignatureGenerator.signature(for: $0) }
    }

    private func getInitializersRemovingDuplicates() -> [Initializer] {
        return protocols.flatMap { $0.initializers }
            .distinctBy { SignatureGenerator.signature(for: $0) }
    }

    private func getPropertiesRemovingDuplicates() -> [Property] {
        let classSignatures = Set(classes.flatMap { $0.properties }
            .map { SignatureGenerator.signature(for: $0) })

        return protocols.flatMap { $0.properties }
            .filter { !classSignatures.contains(SignatureGenerator.signature(for: $0)) }
            .distinctBy { SignatureGenerator.signature(for: $0) }
    }

    private func getMethodsRemovingDuplicates() -> [Method] {
        let classSignatures = Set(classes.flatMap { $0.methods }
            .map { SignatureGenerator.signature(for: $0) })

        return protocols.flatMap { $0.methods }
            .filter { !classSignatures.contains(SignatureGenerator.signature(for: $0)) }
            .distinctBy { SignatureGenerator.signature(for: $0) }
    }

    private func getSubscriptsRemovingDuplicates() -> [Subscript] {
        let classSignatures = Set(classes.flatMap { $0.subscripts }
            .map { SignatureGenerator.signature(for: $0) })

        return protocols.flatMap { $0.subscripts }
            .filter { !classSignatures.contains(SignatureGenerator.signature(for: $0)) }
            .distinctBy { SignatureGenerator.signature(for: $0) }
    }
}

extension Sequence {
    func distinctBy<T: Hashable>(_ keySelector: (Element) -> T) -> [Element] {
        var seen = Set<T>()
        return self.filter { seen.insert(keySelector($0)).inserted }
    }
}
