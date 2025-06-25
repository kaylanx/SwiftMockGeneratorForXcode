//
//  MakeFunctionCallVisitorTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 16/06/2025.
//

import Testing
@testable import MockGenerating

struct MakeFunctionCallVisitorTests {

    @Test
    func shouldCallSimpleMethod() {
        #expect(make { _ in } == "method()")
    }

    @Test
    func shouldCallMethodWithLabelledParameter() {
        let functionCall = make {
            $0.parameter(name: "a") { $0.type("Int") }
        }
        #expect(functionCall == "method(a: a)")
    }

    @Test
    func shouldCallMethodWithWildcardParameter() {
        let functionCall = make {
            $0.parameter(externalName: "_",  internalName: "a") {
                $0.type("Int")
            }
        }
        #expect(functionCall == "method(a)")
    }


    @Test
    func shouldCallMethodWithExternalNameParameter() {
        let functionCall = make {
            $0.parameter(externalName: "a", internalName: "b") {
                $0.type("Int")
            }
        }
        #expect(functionCall == "method(a: b)")
    }

    @Test
    func shouldCallMethodWithMultipleParameters() {
        let functionCall = make {
            $0.parameter(name: "a") { $0.type("Int") }
                .parameter(externalName: "_", internalName: "b") { $0.type("Int") }
                .parameter(externalName: "c", internalName: "d") { $0.type("Int") }
        }
        #expect(functionCall == "method(a: a, b, c: d)")
    }

    @Test
    func shouldCallSubscript() {
        let functionCall = makeSubscript {
            $0.parameter(name: "a") { $0.type("Int") }
                .parameter(externalName: "_", internalName: "b") { $0.type("Int") }
                .parameter(externalName: "c", internalName: "d") { $0.type("Int") }
        }
        #expect(functionCall == "[a, b, c: d]")
    }

    private func make(build: (Method.Builder) -> Void) -> String? {
        let builder = Method.Builder(name: "method")
        build(builder)
        return MakeFunctionCallVisitor.make(element: builder.build())
    }

    private func makeSubscript(build: (Subscript.Builder) -> Void) -> String? {
        let builder = Subscript.Builder(type: TypeIdentifier(identifier: "Int"))
        build(builder)
        return MakeFunctionCallVisitor.make(element: builder.build())
    }
}
