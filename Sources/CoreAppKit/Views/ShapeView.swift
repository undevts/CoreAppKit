#if canImport(UIKit)
import UIKit

open class ShapeView<S>: UIView where S: Shape {
    private var shape: S?
    private var rect = CGRect.zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            shapeLayer?.fillColor = UIColor.systemBackground.cgColor
        } else {
            shapeLayer?.fillColor = UIColor.white.cgColor
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        if #available(iOS 13.0, *) {
            shapeLayer?.fillColor = UIColor.systemBackground.cgColor
        } else {
            shapeLayer?.fillColor = UIColor.white.cgColor
        }
    }
    
    var _backgroundColor: UIColor?
    public override var backgroundColor: UIColor? {
        get {
            _backgroundColor
        }
        set {
            _backgroundColor = newValue
            shapeLayer?.fillColor = newValue?.cgColor
        }
    }
    
    public var shapeLayer: CAShapeLayer? {
        layer as? CAShapeLayer
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateShape()
    }
    
    private func updateShape() {
        guard let shape = shape else {
            return
        }
        let next = bounds
        if next.width > 0 && next.height > 0 && rect.width.isApproximatelyEqual(to: next.width) &&
            rect.height.isApproximatelyEqual(to: next.height) {
            return
        }
        rect = next
        shapeLayer?.path = shape.path(in: next)
    }
    
    public func updateShape(_ shape: S) {
        self.shape = shape
        updateShape()
    }
    
    public func updateShape(_ path: CGPath) {
        shapeLayer?.path = path
    }
    
    public func updateShape(rect: CGRect? = nil, byRounding corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: rect ?? bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        shapeLayer?.path = path.cgPath
    }
    
    public override class var layerClass: AnyClass {
        CAShapeLayer.self
    }
}

#endif // canImport(UIKit)
