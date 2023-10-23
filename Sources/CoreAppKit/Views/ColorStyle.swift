#if canImport(UIKit)
import UIKit

public typealias PlatformColor = UIColor
#elseif canImport(AppKit)
import AppKit

public typealias PlatformColor = NSColor
#endif

public protocol ColorStyleVisitor {
    func visit(solidStyle: SolidColorStyle)
    func visit(gradientStyle: GradientColorStyle)
}

extension ColorStyleVisitor {
    public func visit(solidStyle: SolidColorStyle) {
        // Do nothing.
    }

    public func visit(gradientStyle: GradientColorStyle) {
        // Do nothing.
    }
}

public protocol ColorStyle {
    func accept<Visitor>(_ visitor: Visitor) where Visitor: ColorStyleVisitor
}

extension ColorStyle where Self == SolidColorStyle {
    @inlinable
    public static var none: Self {
        SolidColorStyle(nil)
    }

    @inlinable
    public static func solid(_ color: PlatformColor?) -> Self {
        SolidColorStyle(color)
    }

#if canImport(UIKit)
    @inlinable
    public static func solid(argb value: UInt32) -> Self {
        SolidColorStyle(UIColor(argb: value))
    }

    @inlinable
    public static func solid(rgb value: UInt32, alpha: CGFloat = 1.0) -> Self {
        SolidColorStyle(UIColor(rgb: value, alpha: alpha))
    }
#endif
}

extension ColorStyle where Self == GradientColorStyle {
    @inlinable
    public static func horizontalGradient() -> Self {
        GradientColorStyle(horizontal: true)
    }

    @inlinable
    public static func verticalGradient() -> Self {
        GradientColorStyle(horizontal: false)
    }
}

@frozen
public struct SolidColorStyle: ColorStyle {
    public let color: PlatformColor?

    @inlinable
    public init(_ color: PlatformColor?) {
        self.color = color
    }

    @inlinable
    public func accept<Visitor>(_ visitor: Visitor) where Visitor: ColorStyleVisitor {
        visitor.visit(solidStyle: self)
    }
}

@frozen
public struct GradientColorStyle: ColorStyle {
    public let startColor: PlatformColor?
    public let startPoint: CGPoint
    public let endColor: PlatformColor?
    public let endPoint: CGPoint

    @inlinable
    public init(horizontal: Bool) {
        startColor = nil
        startPoint = horizontal ? CGPoint(x: 0.0, y: 0.5) : CGPoint(x: 0.5, y: 0.0)
        endColor = nil
        endPoint = horizontal ? CGPoint(x: 1.0, y: 0.5) : CGPoint(x: 0.5, y: 1.0)
    }

    @inlinable
    init(startColor: PlatformColor?, startPoint: CGPoint, endColor: PlatformColor?, endPoint: CGPoint) {
        self.startColor = startColor
        self.startPoint = startPoint
        self.endColor = endColor
        self.endPoint = endPoint
    }

    @inlinable
    func with(
        startColor: PlatformColor? = nil,
        startPoint: CGPoint? = nil,
        endColor: PlatformColor? = nil,
        endPoint: CGPoint? = nil
    ) -> GradientColorStyle {
        GradientColorStyle(
            startColor: startColor ?? self.startColor,
            startPoint: startPoint ?? self.startPoint,
            endColor: endColor ?? self.endColor,
            endPoint: endPoint ?? self.endPoint)
    }

    @inlinable
    public func start(_ color: PlatformColor, point: CGPoint) -> GradientColorStyle {
        with(startColor: color, startPoint: point)
    }

    @inlinable
    public func start(_ color: PlatformColor) -> GradientColorStyle {
        with(startColor: color)
    }

    @inlinable
    public func start(_ point: CGPoint) -> GradientColorStyle {
        with(startPoint: point)
    }

    @inlinable
    public func end(_ color: PlatformColor, point: CGPoint) -> GradientColorStyle {
        with(endColor: color, endPoint: point)
    }

    @inlinable
    public func end(_ color: PlatformColor) -> GradientColorStyle {
        with(endColor: color)
    }

    @inlinable
    public func end(_ point: CGPoint) -> GradientColorStyle {
        with(endPoint: point)
    }

#if canImport(UIKit)
    @inlinable
    public func startColor(argb value: UInt32) -> GradientColorStyle {
        with(startColor: UIColor(argb: value))
    }

    @inlinable
    public func startColor(rgb value: UInt32, alpha: CGFloat = 1.0) -> GradientColorStyle {
        with(startColor: UIColor(rgb: value, alpha: alpha))
    }

    @inlinable
    public func endColor(argb value: UInt32) -> GradientColorStyle {
        with(endColor: UIColor(argb: value))
    }

    @inlinable
    public func endColor(rgb value: UInt32, alpha: CGFloat = 1.0) -> GradientColorStyle {
        with(endColor: UIColor(rgb: value, alpha: alpha))
    }
#endif

    @inlinable
    public func accept<Visitor>(_ visitor: Visitor) where Visitor: ColorStyleVisitor {
        visitor.visit(gradientStyle: self)
    }
}
