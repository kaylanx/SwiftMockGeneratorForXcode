@testable import TestProject

class AsyncAwaitProtocolMock: AsyncAwaitProtocol {

    var invokedAsyncAwait = false
    var invokedAsyncAwaitCount = 0

    func asyncAwait() async {
        invokedAsyncAwait = true
        invokedAsyncAwaitCount += 1
    }
}
