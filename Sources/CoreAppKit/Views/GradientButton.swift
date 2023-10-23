#if canImport(UIKit)
import UIKit

public final class GradientButton: UIButton, GradientLayerSetter, GradientLayerView {
    public override var backgroundColor: UIColor? {
        didSet {
            gradientLayer?.colors = nil
        }
    }

    // MARK: - GradientLayerView
    @inlinable
    public var gradientLayer: CAGradientLayer? {
        layer as? CAGradientLayer
    }

    public func setBackgroundColor(startColor: UIColor, startPoint: CGPoint,
        endColor: UIColor, endPoint: CGPoint) {
        guard let layer = gradientLayer else {
            return
        }
        layer.colors = [startColor.cgColor, endColor.cgColor]
        layer.startPoint = startPoint
        layer.endPoint = endPoint
    }

    public func setHorizontalBackgroundColor(startColor: UIColor, endColor: UIColor) {
        setBackgroundColor(startColor: startColor, startPoint: CGPoint(x: 0, y: 0.5),
            endColor: endColor, endPoint: CGPoint(x: 1.0, y: 0.5))
    }

    public func setVerticalBackgroundColor(startColor: UIColor, endColor: UIColor) {
        setBackgroundColor(startColor: startColor, startPoint: CGPoint(x: 0.5, y: 0),
            endColor: endColor, endPoint: CGPoint(x: 0.5, y: 1.0))
    }

    // MARK: - GradientLayerSetter

    @objc
    public var gradientType: CAGradientLayerType = .axial {
        didSet {
            gradientLayer?.type = gradientType
        }
    }

    public func setBackgroundColor<Style>(_ style: Style) where Style: ColorStyle {
        style.accept(self)
    }

    public override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
}

// MARK: - ColorStyleVisitor

extension GradientButton: ColorStyleVisitor {
    public func visit(solidStyle: SolidColorStyle) {
        backgroundColor = solidStyle.color
    }

    public func visit(gradientStyle: GradientColorStyle) {
        guard let layer = gradientLayer,
              let startColor = gradientStyle.startColor,
              let endColor = gradientStyle.endColor
        else {
            return
        }
        layer.colors = [startColor.cgColor, endColor.cgColor]
        layer.startPoint = gradientStyle.startPoint
        layer.endPoint = gradientStyle.endPoint
    }
}

#endif // canImport(UIKit)
