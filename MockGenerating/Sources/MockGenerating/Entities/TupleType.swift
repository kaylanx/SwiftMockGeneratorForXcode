//
//  TupleType.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

import Foundation

struct TupleType: `Type` {
    let tupleElements: [TupleElement]

    init(tupleElements: [TupleElement]) {
        self.tupleElements = tupleElements
    }

    var labels: [String?] {
        tupleElements.map { $0.label }
    }

    var types: [`Type`] {
        tupleElements.map { $0.type }
    }

    var text: String {
        "(" + tupleElements.map { $0.text }.joined(separator: ", ") + ")"
    }

    func accept(visitor: Visitor) {
        visitor.visit(tupleType: self)
    }

    func deepCopy() -> TupleType {
        TupleType(tupleElements: tupleElements.map { $0.deepCopy() })
    }

    // MARK: - Nested TupleElement
    final class TupleElement: Sendable {
        let label: String?
        let type: `Type`

        init(label: String?, type: `Type`) {
            self.label = label
            self.type = type
        }

        var text: String {
            return if let label = label {
                "\(label): \(type.text)"
            } else {
                type.text
            }
        }

        func deepCopy() -> TupleElement {
            TupleElement(label: copyLabel(), type: CopyVisitor.copy(type))
        }

        private func copyLabel() -> String? {
            label.map { "\($0)" }
        }
    }

    // MARK: - Builder
    class Builder {
        private var elements: [TupleElement] = []

        @discardableResult
        func element(_ identifier: String) -> Builder {
            return labelledElement(nil, identifier)
        }

        @discardableResult
        func labelledElement(_ label: String?, _ identifier: String) -> Builder {
            elements.append(TupleElement(label: label, type: TypeIdentifier(identifier: identifier)))
            return self
        }

        @discardableResult
        func element(_ type: `Type`) -> Builder {
            elements.append(TupleElement(label: nil, type: type))
            return self
        }

        func element() -> TypeFactory<Builder> {
            return labelledElement(nil)
        }

        func labelledElement(_ label: String?) -> TypeFactory<Builder> {
            return TypeFactory(previousBuilder: self) { type in
                self.elements.append(TupleElement(label: label, type: type))
            }
        }

        func build() -> TupleType {
            return TupleType(tupleElements: elements)
        }
    }
}
