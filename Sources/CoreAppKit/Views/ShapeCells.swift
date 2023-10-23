#if canImport(UIKit)
import UIKit

public enum CellPosition {
    case top, center, bottom, single

    public func toRectCorner() -> UIRectCorner {
        switch self {
        case .top:
            return [.topLeft, .topRight]
        case .center:
            return []
        case .bottom:
            return [.bottomLeft, .bottomRight]
        case .single:
            return .allCorners
        }
    }
}

open class RoundedCollectionViewCell: UICollectionViewCell {
    public private(set) var position: CellPosition = .center
    public let containerView = ShapeView<RoundedRectangle>(frame: .zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addContainerView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addContainerView()
    }
    
    open func addContainerView() {
        contentView.addSubview(containerView) { maker in
            maker.edges(horizontal: 0, vertical: 0)
        }
    }
    
    open func updateShape(position: CellPosition, radius: CGFloat) {
        self.position = position
        let shape = RoundedRectangle(radius: radius, byRounding: position.toRectCorner())
        containerView.updateShape(shape)
    }
    
    open func updateShape(_ shape: RoundedRectangle, position: CellPosition) {
        self.position = position
        containerView.updateShape(shape)
    }
}

open class RoundedTableViewCell: UITableViewCell {
    public private(set) var position: CellPosition = .center
    public let containerView = ShapeView<RoundedRectangle>(frame: .zero)
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContainerView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addContainerView()
    }
    
    open func addContainerView() {
        contentView.addSubview(containerView) { maker in
            maker.edges(horizontal: 0, vertical: 0)
        }
    }
    
    open func updateShape(position: CellPosition, radius: CGFloat) {
        self.position = position
        let shape = RoundedRectangle(radius: radius, byRounding: position.toRectCorner())
        containerView.updateShape(shape)
    }
    
    open func updateShape(_ shape: RoundedRectangle, position: CellPosition) {
        self.position = position
        containerView.updateShape(shape)
    }
}

#endif // canImport(UIKit)

