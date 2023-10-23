#if canImport(UIKit)
import UIKit

public protocol Shape {
    func path(in rect: CGRect) -> CGPath
}

extension UIBezierPath: Shape {
    public func path(in rect: CGRect) -> CGPath {
        cgPath
    }
}

extension CGPath: Shape {
    public func path(in rect: CGRect) -> CGPath {
        self
    }
}

@frozen
public struct RoundedRectangle: Shape {
    public let radius: CGFloat
    public let corners: UIRectCorner
    
    public init(radius: CGFloat, byRounding corners: UIRectCorner = UIRectCorner.allCorners) {
        self.radius = radius
        self.corners = corners
    }
    
    public func path(in rect: CGRect) -> CGPath {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return path.cgPath
    }
}

#endif // canImport(UIKit)
