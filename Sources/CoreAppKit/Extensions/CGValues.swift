import CoreGraphics

extension CGFloat {
    public var floored: CGFloat {
        CGFloat(floor(self))
    }

    public var ceiled: CGFloat {
        CGFloat(ceil(self))
    }
}

extension CGSize {
    public var floored: CGSize {
        CGSize(width: width.floored, height: height.floored)
    }

    public var rounded: CGSize {
        CGSize(width: width.rounded(), height: height.rounded())
    }

    public var ceiled: CGSize {
        CGSize(width: width.ceiled, height: height.ceiled)
    }
}

extension CGRect {
    public var floored: CGRect {
        CGRect(x: minX.floored, y: minY.floored, width: width.floored, height: height.floored)
    }

    public var rounded: CGRect {
        CGRect(x: minX.rounded(), y: minY.rounded(), width: width.rounded(), height: height.rounded())
    }

    public var ceiled: CGRect {
        CGRect(x: minX.ceiled, y: minY.ceiled, width: width.ceiled, height: height.ceiled)
    }
}
