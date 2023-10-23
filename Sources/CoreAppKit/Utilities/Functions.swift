/// The namespace for functions.
public enum Functions {
    public typealias P0 = () -> Void
    public typealias P0R<R> = () -> R

    public typealias P1<A> = (A) -> Void
    public typealias P1R<A, R> = (A) -> R

    public typealias P2<A, B> = (A, B) -> Void
    public typealias P2R<A, B, R> = (A, B) -> R
}
