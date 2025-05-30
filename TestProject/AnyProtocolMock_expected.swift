protocol ReturnType { }

class AnyProtocolMock: AnyProtocol {

    var invokedTest = false
    var invokedTestCount = 0
    var stubbedTestResult: any ReturnType!

    func test() -> any ReturnType {
        invokedTest = true
        invokedTestCount += 1
        return stubbedTestResult
    }
}
