#if canImport(UIKit)
import UIKit
#endif

// `Identifiable` requires iOS 13.0.
public protocol Identified {
    associatedtype ID: Hashable
    var id: ID { get }
}

extension Hashable where Self: Identified {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public protocol NamedIdentifiable: Identified {
    var name: String { get }
}

public protocol StaticIdentified {
    associatedtype ID: Hashable
    static var id: ID { get }
}

#if canImport(UIKit)
extension StaticIdentified where Self: UIView {
    public static var id: String {
        String(describing: self)
    }
}
#endif // canImport(UIKit)
