protocol AsyncAwaitProtocol {
    func asyncAwait() async
    func throwingAsyncAwait() async throws
    func returningAsyncAwait() async -> Int
    func returingThrowingAsyncAwait() async throws -> Int
    func closureArgumentAsyncAwait(_ closure: @escaping () async -> Void) async
    func throwingClosureArgumentAsyncAwait(_ closure: @escaping () async throws -> Void) async
}
