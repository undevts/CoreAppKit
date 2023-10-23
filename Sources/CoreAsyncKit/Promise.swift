import NIOCore

public typealias Promise<Value> = EventLoopPromise<Value>
public typealias Future<Value> = EventLoopFuture<Value>

extension EventLoopFuture {
    @inlinable
    @preconcurrency
    public func whenSuccess(_ success: @escaping @Sendable (Value) -> Void,
                            failure: @escaping @Sendable (Error) -> Void) {
        whenComplete { result in
            switch result {
            case .success(let value):
                success(value)
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    @inlinable
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func finish() async -> Result<Value, Error> {
        return await withUnsafeContinuation { (x: UnsafeContinuation<Result<Value, Error>, Never>) in
            self.whenComplete { result in
                x.resume(returning: result)
            }
        }
    }

    @inlinable
    public func schedule<Loop>(in eventLoop: Loop) -> Future<Value> where Loop: EventLoop {
        let promise = eventLoop.makePromise(of: Value.self)
        self.whenComplete { result in
            promise.completeWith(result)
        }
        return promise.futureResult
    }
}
