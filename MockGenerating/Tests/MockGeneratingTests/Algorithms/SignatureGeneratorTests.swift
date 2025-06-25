//
//  SignatureGeneratorTest.swift
//  MockGenerating
//
//  Created by Andy Kayley on 17/06/2025.
//
import Testing
@testable import MockGenerating

struct SignatureGeneratorTests  {

    @Test
    func shouldGenerateEmptyMethodSignature() {
        let method = Method.Builder(name: "method").build()
        let signature = getSignature(element: method)
        #expect(signature == "method()")
    }

    @Test
    func shouldGenerateSimpleParameterMethod() {
        let method = Method.Builder(name: "method")
            .parameter(name: "a") { $0.type("A") }
            .build()
        let signature = getSignature(element: method)
        #expect(signature == "method(a:A)")
    }

    @Test
    func shouldChooseParameterExternalNameAndIgnoreInternalName() {
        let method = Method.Builder(name: "method")
            .parameter(externalName: "ext", internalName: "int") {
                $0.type("A")
            }
            .build()
        let signature = getSignature(element: method)
        #expect(signature == "method(ext:A)")
    }

    @Test
    func shouldGenerateMultipleParameters() {
        let method = Method.Builder(name: "method")
            .parameter(name: "a") { $0.type("A") }
            .parameter(name: "b") { $0.type("B") }
            .build()
        let signature = getSignature(element: method)
        #expect(signature == "method(a:A,b:B)")
    }

    @Test
    func shouldGenerateReturnType() {
        let method = Method.Builder(name: "method")
            .returnType(type: "A")
            .build()
        let signature = getSignature(element: method)
        #expect(signature == "method():A")
    }

    @Test
    func shouldGenerateInitializer() {
        let method = Initializer.Builder()
            .parameter("_", "a") { $0.type("A") }
            .parameter("b") { $0.type("B") }
            .build()
        let signature = getSignature(element: method)
        #expect(signature == "init(_:A,b:B)")
    }

    @Test
    func shouldGenerateSignatureForPropertyJustByItsName() {
        let method = Property.Builder(name: "property")
            .type(identifier: "Int")
            .build()
        let signature = getSignature(element: method)
        #expect(signature == "property")
    }

    @Test
    func shouldGenerateSubscript() {
        let `subscript` = Subscript
            .Builder(type: TypeIdentifier(identifier: "Int"))
            .build()
        let signature = getSignature(element: `subscript`)
        #expect(signature == "subscript():Int")
    }

    @Test
    func shouldGenerateSubscriptFromResolvedType() {
        let `subscript` = Subscript.Builder(
            returnType: ResolvedType(
                originalType: TypeIdentifier(
                    identifier: "A"
                ),
                resolvedType: TypeIdentifier(identifier: "B")
            )
        )
            .build()
        let signature = getSignature(element: `subscript`)
        #expect(signature == "subscript():B")
    }

    @Test
    func shouldGenerateSubscriptWithParameters() {
        let `subscript` = Subscript.Builder(
            type: TypeIdentifier(
                identifier: "Int"
            )
        )
        .parameter(name: "a") { $0.type("String") }
        .parameter(externalName: "b", internalName: "c") { $0.type("UInt") }
        .build()

        let signature = getSignature(element: `subscript`)
        #expect(signature == "subscript(a:String,b:UInt):Int")
    }

    private func getSignature(element: Element) -> String {
        SignatureGenerator.signature(for: element)
    }
}
