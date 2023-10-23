// TODO: Replace `class` with `struct`
public enum Delegated {
    @propertyWrapper
    public final class P0 {
        public var wrappedValue: Functions.P0?

        public init() {
            wrappedValue = nil
        }

        public var projectedValue: P0 {
            self
        }
    }

    @propertyWrapper
    public final class P0R<Result> {
        public var wrappedValue: Functions.P0R<Result>?
        private let `default`: Result

        public init(`default`: Result) {
            wrappedValue = nil
            self.default = `default`
        }

        public var projectedValue: P0R<Result> {
            self
        }
    }

    @propertyWrapper
    public final class P1<A> {
        public var wrappedValue: Functions.P1<A>?

        public init() {
            wrappedValue = nil
        }

        public var projectedValue: P1 {
            self
        }
    }

    @propertyWrapper
    public final class P1R<A, Result> {
        public var wrappedValue: Functions.P1R<A, Result>?
        private let `default`: Result

        public init(`default`: Result) {
            wrappedValue = nil
            self.default = `default`
        }

        public var projectedValue: P1R<A, Result> {
            self
        }
    }

    @propertyWrapper
    public final class P2<A, B> {
        public var wrappedValue: Functions.P2<A, B>?

        public init() {
            wrappedValue = nil
        }

        public var projectedValue: P2 {
            self
        }
    }
}

extension Delegated.P0 {
    public func delegate<Target>(to target: Target, _ method: @escaping (Target) -> Void)
        where Target: AnyObject {
        wrappedValue = { [weak target] in
            if let target = target {
                method(target)
            }
        }
    }

    public func delegate<Target>(to target: Target, _ method: @escaping (Target) -> () -> Void)
        where Target: AnyObject {
        wrappedValue = { [weak target] in
            if let target = target {
                method(target)()
            }
        }
    }
}

extension Delegated.P0R {
    public func delegate<Target>(to target: Target, _ method: @escaping (Target) -> Result)
        where Target: AnyObject {
        let value = `default`
        wrappedValue = { [weak target] in
            if let target = target {
                return method(target)
            }
            return value
        }
    }

    public func delegate<Target>(to target: Target, _ method: @escaping (Target) -> () -> Result)
        where Target: AnyObject {
        let value = `default`
        wrappedValue = { [weak target] in
            if let target = target {
                return method(target)()
            }
            return value
        }
    }
}

extension Delegated.P1 {
    public func delegate<Target>(to target: Target, _ method: @escaping (Target, A) -> Void)
        where Target: AnyObject {
        wrappedValue = { [weak target] a in
            if let target = target {
                method(target, a)
            }
        }
    }

    public func delegate<Target>(to target: Target, _ method: @escaping (Target) -> (A) -> Void)
        where Target: AnyObject {
        wrappedValue = { [weak target] a in
            if let target = target {
                method(target)(a)
            }
        }
    }
}

extension Delegated.P1R {
    public func delegate<Target>(to target: Target, _ method: @escaping (Target, A) -> Result)
        where Target: AnyObject {
        let value = `default`
        wrappedValue = { [weak target] a in
            if let target = target {
                return method(target, a)
            }
            return value
        }
    }

    public func delegate<Target>(to target: Target, _ method: @escaping (Target) -> (A) -> Result)
        where Target: AnyObject {
        let value = `default`
        wrappedValue = { [weak target] a in
            if let target = target {
                return method(target)(a)
            }
            return value
        }
    }
}

extension Delegated.P2 {
    public func delegate<Target>(to target: Target, _ method: @escaping (Target, A, B) -> Void)
        where Target: AnyObject {
        wrappedValue = { [weak target] a, b in
            if let target = target {
                method(target, a, b)
            }
        }
    }

    public func delegate<Target>(to target: Target, _ method: @escaping (Target) -> (A, B) -> Void)
        where Target: AnyObject {
        wrappedValue = { [weak target] a, b in
            if let target = target {
                method(target)(a, b)
            }
        }
    }
}
