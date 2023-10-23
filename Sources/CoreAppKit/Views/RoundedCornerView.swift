#if canImport(UIKit)

import UIKit
import QuartzCore

class RoundedCornerView: UIView {
    private var shapeLayer: CAShapeLayer? {
        layer as? CAShapeLayer
    }
    private var radii = CGSize.zero
    private var corners: UIRectCorner = []

    var pathFrame: CGRect = .zero {
        didSet {
            if oldValue != pathFrame {
                resetPath()
            }
        }
    }

    override var backgroundColor: UIColor? {
        get {
            shapeLayer?.fillColor.map(UIColor.init)
        }
        set {
            shapeLayer?.fillColor = newValue?.cgColor
        }
    }

    override class var layerClass: AnyClass {
        CAShapeLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }

    func initialization() {
        pathFrame = frame
        if !pathFrame.isEmpty {
            resetPath()
        }
    }

    func setRoundingCorner(_ corners: UIRectCorner, radii: CGFloat) {
        self.corners = corners
        self.radii = CGSize(width: radii, height: radii)
        resetPath()
    }

    func setRoundingCorner(topLeft: CGFloat? = nil, topRight: CGFloat? = nil,
        bottomLeft: CGFloat? = nil, bottomRight: CGFloat? = nil) {
        let value = topLeft ?? topRight ?? bottomLeft ?? bottomRight ?? 0
        var corners: UIRectCorner = []
        if topLeft != nil {
            corners.update(with: .topLeft)
        }
        if topRight != nil {
            corners.update(with: .topRight)
        }
        if bottomLeft != nil {
            corners.update(with: .bottomLeft)
        }
        if bottomRight != nil {
            corners.update(with: .bottomRight)
        }
        setRoundingCorner(corners, radii: value)
    }

    func setRoundingCorner(_ corners: [CGFloat]) {
        precondition(corners.count == 4)
        setRoundingCorner(topLeft: corners.at(0), topRight: corners.at(1),
            bottomLeft: corners.at(2), bottomRight: corners.at(3))
    }

    private func resetPath() {
        let path = UIBezierPath(roundedRect: pathFrame, byRoundingCorners: corners, cornerRadii: radii)
        shapeLayer?.path = path.cgPath
    }
}

extension RoundedCornerView {
    func setRoundingCorner(_ radii: CGFloat, position: CellPosition) {
        switch position {
        case .top:
            setRoundingCorner(topLeft: radii, topRight: radii, bottomLeft: nil, bottomRight: nil)
        case .center:
            setRoundingCorner(topLeft: nil, topRight: nil, bottomLeft: nil, bottomRight: nil)
        case .bottom:
            setRoundingCorner(topLeft: nil, topRight: nil, bottomLeft: radii, bottomRight: radii)
        case .single:
            setRoundingCorner(topLeft: radii, topRight: radii, bottomLeft: radii, bottomRight: radii)
        }
    }
}

#endif // canImport(UIKit)
