@testable import TestProject

class AsyncAwaitProtocolMock: AsyncAwaitProtocol {

    var invokedAsyncAwait = false
    var invokedAsyncAwaitCount = 0

    func asyncAwait() async {
        invokedAsyncAwait = true
        invokedAsyncAwaitCount += 1
    }

    var invokedThrowingAsyncAwait = false
    var invokedThrowingAsyncAwaitCount = 0
    var stubbedThrowingAsyncAwaitError: Error?

    func throwingAsyncAwait() async throws {
        invokedThrowingAsyncAwait = true
        invokedThrowingAsyncAwaitCount += 1
        if let error = stubbedThrowingAsyncAwaitError {
            throw error
        }
    }

    var invokedReturningAsyncAwait = false
    var invokedReturningAsyncAwaitCount = 0
    var stubbedReturningAsyncAwaitResult: Int! = 0

    func returningAsyncAwait() async -> Int {
        invokedReturningAsyncAwait = true
        invokedReturningAsyncAwaitCount += 1
        return stubbedReturningAsyncAwaitResult
    }

    var invokedReturingThrowingAsyncAwait = false
    var invokedReturingThrowingAsyncAwaitCount = 0
    var stubbedReturingThrowingAsyncAwaitError: Error?
    var stubbedReturingThrowingAsyncAwaitResult: Int! = 0

    func returingThrowingAsyncAwait() async throws -> Int {
        invokedReturingThrowingAsyncAwait = true
        invokedReturingThrowingAsyncAwaitCount += 1
        if let error = stubbedReturingThrowingAsyncAwaitError {
            throw error
        }
        return stubbedReturingThrowingAsyncAwaitResult
    }

    var invokedClosureArgumentAsyncAwait = false
    var invokedClosureArgumentAsyncAwaitCount = 0
    var shouldInvokeClosureArgumentAsyncAwaitClosure = false

    func closureArgumentAsyncAwait(_ closure: @escaping () async -> Void) async {
        invokedClosureArgumentAsyncAwait = true
        invokedClosureArgumentAsyncAwaitCount += 1
        if shouldInvokeClosureArgumentAsyncAwaitClosure {
            await closure()
        }
    }

    var invokedThrowingClosureArgumentAsyncAwait = false
    var invokedThrowingClosureArgumentAsyncAwaitCount = 0
    var shouldInvokeThrowingClosureArgumentAsyncAwaitClosure = false

    func throwingClosureArgumentAsyncAwait(_ closure: @escaping () async throws -> Void) async {
        invokedThrowingClosureArgumentAsyncAwait = true
        invokedThrowingClosureArgumentAsyncAwaitCount += 1
        if shouldInvokeThrowingClosureArgumentAsyncAwaitClosure {
            try? await closure()
        }
    }
}
