import Darwin.C
import Dispatch

public final class MainEventLoop: DispatchQueueEventLoop {
    public static let instance = MainEventLoop()

    private init() {
        // Do nothing.
    }

    @inline(__always)
    public var inEventLoop: Bool {
        // The pthread_main_np() function returns 1 if the calling thread is the initial thread,
        // 0 if the calling thread is not the initial thread,
        // and -1 if the thread's initialization has not yet completed.
        pthread_main_np() == 1
    }

    @inline(__always)
    public var queue: DispatchQueue {
        DispatchQueue.main
    }

    public func shutdownGracefully(queue: DispatchQueue, _ callback: @escaping (Error?) -> Void) {
        assert(false, "Main event loop cannot manual shutdown!")
    }
}
