//
//  Initializer.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

import Foundation

class Initializer: Element {
    let parametersList: [Parameter]
    let isFailable: Bool
    let `async`: Bool
    let `throws`: Bool

    init(parametersList: [Parameter], isFailable: Bool, `async`: Bool, `throws`: Bool) {
        self.parametersList = parametersList
        self.isFailable = isFailable
        self.`async` = `async`
        self.`throws` = `throws`
    }

    func accept(visitor: Visitor) {
        visitor.visit(initializer: self)
    }

    class Builder {
        private var parameters: [Parameter] = []
        private var isFailable: Bool = false
        private var _async: Bool = false
        private var _throws: Bool = false

        @discardableResult
        func failable() -> Builder {
            self.isFailable = true
            return self
        }

        @discardableResult
        func `async`() -> Builder {
            self._async = true
            return self
        }

        @discardableResult
        func `throws`() -> Builder {
            self._throws = true
            return self
        }

        @discardableResult
        func parameter(_ name: String, build: (Parameter.Builder) -> Void) -> Builder {
            let builder = Parameter.Builder(name: name)
            build(builder)
            return parameter(builder.build())
        }

        @discardableResult
        func parameter(_ externalName: String, _ internalName: String, build: (Parameter.Builder) -> Void) -> Builder {
            let builder = Parameter.Builder(externalName: externalName, internalName: internalName)
            build(builder)
            return parameter(builder.build())
        }

        @discardableResult
        private func parameter(_ parameter: Parameter) -> Builder {
            parameters.append(parameter)
            return self
        }

        func build() -> Initializer {
            return Initializer(
                parametersList: parameters,
                isFailable: isFailable,
                async: _async,
                throws: _throws
            )
        }
    }
}
