//
//  Method.swift
//  MockGenerating
//
//  Created by Andy Kayley on 02/06/2025.
//

struct Method: Element, Equatable {

    let name: String
    let genericParameters: [String]
    let returnType: ResolvedType
    let parametersList: [Parameter]
    let declarationText: String
    let `async`: Bool
    let `throws`: Bool
    let `rethrows`: Bool

    func accept(visitor: Visitor) {
        visitor.visit(method: self)
    }

    class Builder {

        private var _returnType = ResolvedTypes.implicit.type
        private var _throws = false
        private var _rethrows = false
        private var _async = false
        private var parameters = [Parameter]()
        private var _genericParameters = [String]()

        private let name: String

        init(name: String) {
            self.name = name
        }

        func build() -> Method {
            return Method(
                name: name,
                genericParameters: _genericParameters,
                returnType: _returnType,
                parametersList: parameters,
                declarationText: getDeclarationText(),
                async: _async,
                throws: _throws,
                rethrows: _rethrows
            )
        }

        func returnType(type: String) -> Builder {
            _returnType = ResolvedType.Builder(type: type).build()
            return self
        }

        func returnType() -> TypeFactory<Builder> {
            return TypeFactory(previousBuilder: self) { [weak self] in
                self?._returnType = ResolvedType(originalType: $0, resolvedType: $0)
            }
        }

        func `async`() -> Builder {
            _async = true
            return self
        }

        func `throws`() -> Builder {
            _throws = true
            return self
        }

        func `rethrows`() -> Builder {
            _rethrows = true
            return self
        }

        @discardableResult
        func parameter(name: String, build: (Parameter.Builder) -> Void) -> Builder {
            return parameter(externalName: nil, internalName: name, build: build)
        }

        @discardableResult
        func parameter(externalName: String?, internalName: String, build: (Parameter.Builder) -> Void) -> Builder {
            let builder = Parameter.Builder(externalName: externalName, internalName: internalName)
            build(builder)
            return parameter(parameter: builder.build())
        }

        private func parameter(parameter: Parameter) -> Builder {
            parameters.append(parameter)
            return self
        }

        func genericParameter(identifier: String) -> Builder {
            _genericParameters.append(identifier)
            return self
        }

        private func getDeclarationText() -> String {
            var returnString = ""
            var throwString = ""
            var asyncString = ""
            let parametersString: String = parameters.map { $0.text }.joined(separator: ", ")
            if _returnType !== ResolvedTypes.implicit.type {
                returnString = " -> \(_returnType.originalType.text)"
            }
            if _async {
                asyncString = " async"
            }
            if _throws {
                throwString = " throws"
            } else if _rethrows {
                throwString = " rethrows"
            }
            return "func \(name)\(getGenericClauseText())(\(parametersString))\(asyncString)\(throwString)\(returnString)"
        }

        private func getGenericClauseText() -> String {
            guard _genericParameters.isEmpty == false else {
                return ""
            }
            let list = _genericParameters.joined(separator: ", ")
            return "<\(list)>"
        }
    }
}
