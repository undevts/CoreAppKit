import Dispatch
import NIOCore
import Atomics

public protocol DispatchQueueEventLoop: EventLoop {
    var queue: DispatchQueue { get }
}

extension DispatchQueueEventLoop {
    @inlinable
    public func execute(_ task: @escaping () -> Void) {
        queue.async(execute: task)
    }

    public func scheduleTask<T>(deadline: NIODeadline, _ task: @escaping () throws -> T) -> Scheduled<T> {
        let promise: EventLoopPromise<T> = makePromise()
        let work = DispatchWorkItem {
            do {
                promise.succeed(try task())
            } catch {
                promise.fail(error)
            }
        }
        let scheduled = Scheduled<T>(promise: promise) {
            work.cancel()
        }
        let time = DispatchTime(uptimeNanoseconds: deadline.uptimeNanoseconds)
        queue.asyncAfter(deadline: time, execute: work)
        return scheduled
    }

    public func scheduleTask<T>(in amount: TimeAmount, _ task: @escaping () throws -> T) -> Scheduled<T> {
        let promise: EventLoopPromise<T> = makePromise()
        let work = DispatchWorkItem {
            do {
                promise.succeed(try task())
            } catch {
                promise.fail(error)
            }
        }
        let scheduled = Scheduled<T>(promise: promise) {
            work.cancel()
        }
        let interval: DispatchTimeInterval
        if let nanoseconds = Int(exactly: amount.nanoseconds) {
            interval = DispatchTimeInterval.nanoseconds(nanoseconds)
        } else { // amount.nanoseconds > Int32.max
            interval = DispatchTimeInterval.seconds(Int(amount.nanoseconds / 10_0000_0000))
        }
        let time = DispatchWallTime.now() + interval
        DispatchQueue.main.asyncAfter(wallDeadline: time, execute: work)
        return scheduled
    }

    public func shutdownGracefully(queue: DispatchQueue, _ callback: @escaping (Error?) -> Void) {
        assert(false, "\(Self.self) cannot manual shutdown!")
    }
}

private let loopIdGenerator = ManagedAtomic<UInt64>(0)

public final class DispatchEventLoop: DispatchQueueEventLoop {
    private static let key = DispatchSpecificKey<UInt64>()
    public let queue: DispatchQueue
    let id: UInt64

    public var inEventLoop: Bool {
        DispatchQueue.getSpecific(key: DispatchEventLoop.key) == id
    }

    public init(queue: DispatchQueue) {
        precondition(queue !== DispatchQueue.main, "Please use 'MainEventLoop'")
        self.queue = queue
        if let id = queue.getSpecific(key: DispatchEventLoop.key) {
            self.id = id
        } else {
            id = loopIdGenerator.wrappingIncrementThenLoad(ordering: .relaxed)
            queue.setSpecific(key: DispatchEventLoop.key, value: id)
        }
    }

    @inlinable
    @available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    public func preconditionInEventLoop() {
        dispatchPrecondition(condition: .onQueue(queue))
    }

    @inlinable
    @available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    public func preconditionNotInEventLoop() {
        dispatchPrecondition(condition: .notOnQueue(queue))
    }
}
