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

    @Test
    func shouldVisitFunctionInnerTypes() {
        let function = FunctionType.Builder()
            .argument(type: "A")
            .argument(type: "B")
            .returnType(type: "C")
            .build()
        function.accept(visitor: visitor)
        #expect(visitor.visitedFunctionTypes[0] == function)
        #expect(visitor.visitedTypes.count == 3)
        #expect(function.arguments.count == 2)
        #expect(visitor.visitedTypes[0].text == function.arguments[0].text)
        #expect(visitor.visitedTypes[1].text == function.arguments[1].text)
        #expect(visitor.visitedTypes[2].text == function.returnType.text)
    }

    @Test
    func shouldVisitOptionalInnerType() {
        let optional = OptionalType.Builder().type(type: "Type").build()
        optional.accept(visitor: visitor)
        #expect(optional == visitor.visitedOptionalTypes[0])
        #expect(optional.type.text == visitor.visitedTypes[0].text)
    }

    @Test
    func shouldVisitTupleInnerType() throws {
        let optional = OptionalType.Builder().type().bracket().type("Type").build()
        let tuple = try #require(optional.type as? TupleType)
        optional.accept(visitor: visitor)
        #expect(optional == visitor.visitedOptionalTypes[0])
        #expect(tuple == visitor.visitedTupleTypes[0])
        #expect(tuple.types[0].text == visitor.visitedTypes[0].text)
    }

    @Test
    func shouldVisitArrayInnerType() {
        let array = ArrayType.Builder().type(type: "Type").build()
        array.accept(visitor: visitor)
        #expect(array == visitor.visitedArrayTypes[0])
        #expect(array.type.text == visitor.visitedTypes[0].text)
    }


    @Test
    func shouldVisitDictionaryKeyAndValueTypes() {
        let dictionary = DictionaryType.Builder()
            .keyType(type: "Key")
            .valueType(type: "Value")
            .build()
        dictionary.accept(visitor: visitor)
        #expect(dictionary == visitor.visitedDictionaryTypes[0])
        #expect(dictionary.keyType.text == visitor.visitedTypes[0].text)
        #expect(dictionary.valueType.text == visitor.visitedTypes[1].text)
    }

    @Test
    func shouldVisitGenericTypes() {
        let generic = GenericType.Builder(identifier: "Type")
            .argument(identifier: "T")
            .argument(identifier: "U")
            .build()
        generic.accept(visitor: visitor)
        #expect(visitor.visitedGenericTypes[0] == generic)
        #expect(visitor.visitedTypes[0].text == generic.arguments[0].text)
        #expect(visitor.visitedTypes[1].text == generic.arguments[1].text)
    }

    @Test
    func shouldVisitMethodChildren() {
        let declaration = Method.Builder(name: "method")
            .parameter(name: "a") { $0.type("Int") }
            .returnType(type: "String")
            .build()
        declaration.accept(visitor: visitor)
        #expect(visitor.visitedMethods[0] == declaration)
        #expect(visitor.visitedParameters[0] == declaration.parametersList[0])
        #expect(visitor.visitedTypes[0].text == declaration.parametersList[0].type.resolvedType.text)
        #expect(visitor.visitedTypes[1].text == declaration.returnType.resolvedType.text)
    }

    @Test
    func shouldVisitPropertyChildren() {
        let declaration = Property.Builder(name: "prop")
            .type(identifier: "String")
            .build()
        declaration.accept(visitor: visitor)
        #expect(visitor.visitedProperties[0] == declaration)
        #expect(visitor.visitedTypes[0].text == declaration.type.text)
    }

    @Test
    func shouldVisitInitializerChildren() {
        let declaration = Initializer.Builder()
            .parameter("a") { $0.type("Int") }
            .build()
        declaration.accept(visitor: visitor)
        #expect(visitor.visitedInitializers[0] == declaration)
        #expect(visitor.visitedParameters[0] == declaration.parametersList[0])
    }

    @Test
    func shouldVisitParameterChildren() {
        let parameter = Parameter.Builder(name: "a")
            .type("Int")
            .build()
        parameter.accept(visitor: visitor)
        #expect(visitor.visitedParameters[0] == parameter)
        #expect(visitor.visitedTypes[0].text == parameter.type.resolvedType.text)
    }

    @Test
    func shouldVisitTupleTypes() {
        let tuple = TupleType.Builder()
            .element("A")
            .element("B")
            .build()
        tuple.accept(visitor: visitor)
        #expect(tuple.types[0].text == visitor.visitedTypes[0].text)
        #expect(tuple.types[1].text == visitor.visitedTypes[1].text)
    }
}
