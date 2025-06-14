//
//  RecursiveVisitorTests.swift
//  MockGenerating
//
//  Created by Andy Kayley on 14/06/2025.
//
import Testing
@testable import MockGenerating

struct RecursiveVisitorTest {

    private let visitor = RecursiveVisitorSpy()

    @Test(.disabled())
    func shouldVisitFunctionInnerTypes() {
        let function = FunctionType.Builder()
            .argument(type: "A")
            .argument(type: "B")
            .returnType(type: "C")
            .build()
        function.accept(visitor: visitor)
        #expect(visitor.visitedFunctionTypes[0] == function)
        #expect(visitor.visitedTypes[0].text == function.arguments[0].text)
        #expect(visitor.visitedTypes[1].text == function.arguments[1].text)
        #expect(visitor.visitedTypes[2].text == function.returnType.text)
    }
/*
    @Test
    func shouldVisitOptionalInnerType() {
        let optional = OptionalType.Builder().type("Type").build()
        optional.accept(visitor)
        assertEquals(visitor.visitedOptionalTypes[0], optional)
        assertEquals(visitor.visitedTypes[0], optional.type)
    }

    @Test
    func shouldVisitTupleInnerType() {
        let optional = OptionalType.Builder().type().bracket().type("Type").build()
        let tuple = optional.type as TupleType
        optional.accept(visitor)
        assertEquals(visitor.visitedOptionalTypes[0], optional)
        assertEquals(visitor.visitedTupleTypes[0], tuple)
        assertEquals(visitor.visitedTypes[0], tuple.types[0])
    }

    @Test
    func shouldVisitArrayInnerType() {
        let array = ArrayType.Builder().type("Type").build()
        array.accept(visitor)
        assertEquals(visitor.visitedArrayTypes[0], array)
        assertEquals(visitor.visitedTypes[0], array.type)
    }

    @Test
    func shouldVisitDictionaryKeyAndValueTypes() {
        let dictionary = DictionaryType.Builder()
            .keyType("Key")
            .valueType("Value")
            .build()
        dictionary.accept(visitor)
        assertEquals(visitor.visitedDictionaryTypes[0], dictionary)
        assertEquals(visitor.visitedTypes[0], dictionary.keyType)
        assertEquals(visitor.visitedTypes[1], dictionary.valueType)
    }

    @Test
    func shouldVisitGenericTypes() {
        let generic = GenericType.Builder("Type")
            .argument("T")
            .argument("U")
            .build()
        generic.accept(visitor)
        assertEquals(visitor.visitedGenericTypes[0], generic)
        assertEquals(visitor.visitedTypes[0], generic.arguments[0])
        assertEquals(visitor.visitedTypes[1], generic.arguments[1])
    }

    @Test
    func shouldVisitMethodChildren() {
        let declaration = Method.Builder("method")
            .parameter("a") { it.type("Int") }
            .returnType("String")
            .build()
        declaration.accept(visitor)
        assertEquals(visitor.visitedMethods[0], declaration)
        assertEquals(visitor.visitedParameters[0], declaration.parametersList[0])
        assertEquals(visitor.visitedTypes[0], declaration.parametersList[0].type.resolvedType)
        assertEquals(visitor.visitedTypes[1], declaration.returnType.resolvedType)
    }

    @Test
    func shouldVisitPropertyChildren() {
        let declaration = Property.Builder("prop")
            .type("String")
            .build()
        declaration.accept(visitor)
        assertEquals(visitor.visitedProperties[0], declaration)
        assertEquals(visitor.visitedTypes[0], declaration.type)
    }

    @Test
    func shouldVisitInitializerChildren() {
        let declaration = Initializer.Builder()
            .parameter("a") { it.type("Int") }
            .build()
        declaration.accept(visitor)
        assertEquals(visitor.visitedInitializers[0], declaration)
        assertEquals(visitor.visitedParameters[0], declaration.parametersList[0])
    }

    @Test
    func shouldVisitParameterChildren() {
        let parameter = Parameter.Builder("a")
            .type("Int")
            .build()
        parameter.accept(visitor)
        assertEquals(visitor.visitedParameters[0], parameter)
        assertEquals(visitor.visitedTypes[0], parameter.type.resolvedType)
    }

    @Test
    func shouldVisitTupleTypes() {
        let tuple = TupleType.Builder()
            .element("A")
            .element("B")
            .build()
        tuple.accept(visitor)
        assertEquals(tuple.types[0], visitor.visitedTypes[0])
        assertEquals(tuple.types[1], visitor.visitedTypes[1])
    }
 */
}
