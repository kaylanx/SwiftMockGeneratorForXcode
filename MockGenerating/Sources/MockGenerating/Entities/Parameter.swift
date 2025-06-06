//
//  Parameter.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

import Foundation

class Parameter: Element, Equatable {

    static func == (lhs: Parameter, rhs: Parameter) -> Bool {
        lhs.externalName == rhs.externalName &&
        lhs.internalName == rhs.internalName &&
        lhs.type == rhs.type &&
        lhs.text == rhs.text &&
        lhs.isEscaping == rhs.isEscaping
    }

    let externalName: String?
    let internalName: String
    let type: ResolvedType
    let text: String
    let isEscaping: Bool

    var originalTypeText: String {
        return type.originalType.text
    }

    var resolvedTypeText: String {
        return type.resolvedType.text
    }

    init(externalName: String?, internalName: String, type: ResolvedType, text: String, isEscaping: Bool) {
        self.externalName = externalName
        self.internalName = internalName
        self.type = type
        self.text = text
        self.isEscaping = isEscaping
    }

    func accept(visitor: Visitor) {
        visitor.visit(parameter: self)
    }

    class Builder {
        private let externalName: String?
        private let internalName: String
        private var _type: ResolvedType = .implicit
        private var isEscaping: Bool = false
        private var annotations: [String] = []
        private var isInout: Bool = false

        init(name: String) {
            self.externalName = nil
            self.internalName = name
        }

        init(externalName: String?, internalName: String) {
            self.externalName = externalName
            self.internalName = internalName
        }

        @discardableResult
        func type(_ string: String) -> Builder {
            let type = TypeIdentifier(identifier: string)
            self._type = ResolvedType(originalType: type, resolvedType: type)
            return self
        }

        func type() -> TypeFactory<Builder> {
            return TypeFactory(previousBuilder: self) { [weak self] newType in
                self?._type = ResolvedType(originalType: newType, resolvedType: newType)
            }
        }

        func resolvedType() -> TypeFactory<Builder> {
            return TypeFactory(previousBuilder: self) { [weak self] newType in
                guard let self else { return }
                _type = ResolvedType(originalType: _type.originalType, resolvedType: newType)
            }
        }

        @discardableResult
        func escaping() -> Builder {
            self.isEscaping = true
            return annotation("@escaping")
        }

        @discardableResult
        func annotation(_ annotation: String) -> Builder {
            self.annotations.append(annotation)
            return self
        }

        @discardableResult
        func `inout`() -> Builder {
            self.isInout = true
            return self
        }

        func build() -> Parameter {
            return Parameter(
                externalName: externalName,
                internalName: internalName,
                type: _type,
                text: getText(),
                isEscaping: isEscaping
            )
        }

        private func getText() -> String {
            var labels = internalName
            if let ext = externalName, !ext.isEmpty {
                labels = "\(ext) \(labels)"
            }

            let annotationText = annotations.isEmpty ? "" : annotations.joined(separator: " ") + " "
            let inoutText = isInout ? "inout " : ""
            return "\(labels): \(inoutText)\(annotationText)\(_type.originalType.text)"
        }
    }
}
