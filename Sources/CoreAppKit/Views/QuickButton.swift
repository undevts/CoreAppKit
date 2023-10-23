#if os(iOS)
import UIKit
import LayoutKit

@objc
public enum QuickButtonLayout: Int {
    case none
    case textLeft
    case textRight
    case textTop
    case textBottom
}

@objc
public enum QuickButtonBaseline: Int {
    case none
    case image
    case label
}

enum ControlState: Hashable {
    case normal
    case highlighted
    case disabled
    case selected
    case focused
    case application
    case reserved

    static func from(state: UIControl.State) -> [ControlState] {
        var result: [ControlState] = []
        // The normal, or default state of a control—that is, enabled but neither selected nor highlighted.
        if state.contains(.highlighted) {
            result.append(.highlighted)
        }
        if state.contains(.disabled) {
            result.append(.disabled)
        }
        if state.contains(.selected) {
            result.append(.selected)
        }
        if state.isEmpty && state.contains(.normal) {
            result.append(.normal)
        }
        if state.contains(.focused) {
            result.append(.focused)
        }
        if state.contains(.application) {
            result.append(.application)
        }
        if state.contains(.reserved) {
            result.append(.reserved)
        }
        return result
    }
}

open class QuickButton: UIButton {
    @objc
    public let iconImageView: UIImageView = UIImageView(frame: .zero)
    @objc
    public let textLabel: UILabel = UILabel(frame: .zero)
    @objc
    public let badgeLabel = UILabel(frame: .zero)
    private var imageViewConstraints: [NSLayoutConstraint] = []
    private var textLabelConstraints: [NSLayoutConstraint] = []
    private var badgeLabelConstraints: [NSLayoutConstraint] = []

    private var badgeTopConstraint: NSLayoutConstraint?
    private var badgeRightConstraint: NSLayoutConstraint?
    private var badgeWidthConstraint: NSLayoutConstraint?
    private var badgeHeightConstraint: NSLayoutConstraint?

    private var imageMap: [ControlState: UIImage] = [:]

    public var badge: Int? {
        didSet {
            reloadBadge()
        }
    }

    
    public var badgeOffset: CGPoint = CGPoint.zero {
        didSet {
            reloadBadge()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }

    private func initialization() {
        badgeLabel.isHidden = true
        badgeLabel.backgroundColor = UIColor(argb: 0xFF6B6B)
        badgeLabel.textColor = UIColor.white
        badgeLabel.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        badgeLabel.textAlignment = .center
        badgeLabel.clipsToBounds = true

        addSubview(iconImageView)
        addSubview(textLabel)
        badgeLabelConstraints = addSubview(badgeLabel) { maker in
            badgeTopConstraint = maker.top(inset: 0)
            badgeRightConstraint = maker.right(inset: 0)
            badgeWidthConstraint = maker.width(14)
            badgeHeightConstraint = maker.height(14)
        }
    }

    open override var isEnabled: Bool {
        didSet {
            reloadImage(state: currentState)
        }
    }

    open override var isSelected: Bool {
        didSet {
            reloadImage(state: currentState)
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            reloadImage(state: currentState)
        }
    }

    open override func setImage(_ image: UIImage?, for state: State) {
        let states = ControlState.from(state: state)
        states.forEach { state in
            imageMap[state] = image
        }
        reloadImage(state: currentState)
    }

    var currentState: ControlState {
        guard isEnabled else {
            return .disabled
        }
        if isHighlighted {
            return .highlighted
        }
        if isSelected {
            return .selected
        }
        if isFocused {
            return .focused
        }
        return .normal
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        systemLayoutSizeFitting(size)
    }

    private func reloadImage(state: ControlState) {
        if iconImageView.image != nil && imageMap.isEmpty {
            // 手动设置了图片
            return
        }
        var image = imageMap[state]
        if image == nil {
            switch state {
            case .highlighted:
                image = imageMap[.selected]
            case .selected:
                image = imageMap[.highlighted]
            default:
                break
            }
            image = image ?? imageMap[.normal]
        }
        iconImageView.image = image
    }

    public func quickLayout(_ layout: QuickButtonLayout, imageSize: CGSize?,
        baseline: QuickButtonBaseline = .image, space: CGFloat = 0) {
        let basedOnImage = baseline == .image
        let basedOnLabel = baseline == .label
        let hasImageSize = imageSize != nil
        makeConstraints { maker in
            switch layout {
            case .textLeft:
                maker.right()
                if hasImageSize {
                    maker.size(imageSize ?? CGSize.zero)
                }
                if basedOnImage {
                    maker.edges(vertical: 0)
                } else {
                    maker.centerY()
                }
            case .textRight:
                maker.left()
                if hasImageSize {
                    maker.size(imageSize ?? CGSize.zero)
                }
                if basedOnImage {
                    maker.edges(vertical: 0)
                } else {
                    maker.centerY()
                }
            case .textTop:
                maker.bottom()
                if hasImageSize {
                    maker.size(imageSize ?? CGSize.zero)
                }
                if basedOnImage {
                    maker.edges(horizontal: 0)
                } else {
                    maker.centerX()
                }
            case .textBottom:
                maker.top()
                if hasImageSize {
                    maker.size(imageSize ?? CGSize.zero)
                }
                if basedOnImage {
                    maker.edges(horizontal: 0)
                } else {
                    maker.centerX()
                }
            case .none:
                break
            }
        } textLabel: { maker in
            switch layout {
            case .textLeft:
                maker.left()
                if basedOnLabel {
                    maker.edges(vertical: 0)
                } else {
                    maker.centerY()
                }
                maker.right(to: iconImageView, edge: .left, offset: -space, by: .equal)
            case .textRight:
                maker.right()
                if basedOnLabel {
                    maker.edges(vertical: 0)
                } else {
                    maker.centerY()
                }
                maker.left(to: iconImageView, edge: .right, offset: space, by: .equal)
            case .textTop:
                maker.top()
                if basedOnLabel {
                    maker.edges(horizontal: 0)
                } else {
                    maker.centerX()
                }
                maker.bottom(to: iconImageView, edge: .top, offset: -space, by: .equal)
            case .textBottom:
                maker.bottom()
                if basedOnLabel {
                    maker.edges(horizontal: 0)
                } else {
                    maker.centerX()
                }
                maker.top(to: iconImageView, edge: .bottom, offset: space, by: .equal)
            case .none:
                break
            }
        }
    }
    
    @objc
    public func quickLayout(_ layout: QuickButtonLayout, baseline: QuickButtonBaseline, space: CGFloat) {
        quickLayout(layout, imageSize: nil, baseline: baseline, space: space)
    }
    
    @objc
    public func quickLayout(_ layout: QuickButtonLayout, image imageSize: CGSize, baseline: QuickButtonBaseline, space: CGFloat) {
        quickLayout(layout, imageSize: imageSize, baseline: baseline, space: space)
    }

    @objc
    public func makeConstraints(imageView: (AutoMaker) -> Void, textLabel: (AutoMaker) -> Void) {
        imageViewConstraints = iconImageView.autoRemake(constraints: imageViewConstraints, imageView)
        textLabelConstraints = self.textLabel.autoRemake(constraints: textLabelConstraints, textLabel)
    }

    @objc
    public func makeBadgeConstraints(_ maker: (AutoMaker) -> Void) {
        badgeLabelConstraints = badgeLabel.autoRemake(constraints: badgeLabelConstraints, maker)
        if badgeLabelConstraints.isNotEmpty {
            badgeTopConstraint = nil
            badgeRightConstraint = nil
            badgeWidthConstraint = nil
            badgeHeightConstraint = nil
        }
    }
    
    @objc
    public func reloadBadge(_ badge: Int) {
        self.badge = badge < 1 ? nil : badge
    }

    private func reloadBadge() {
        guard let badge = badge else {
            badgeLabel.isHidden = true
            return
        }
        badgeLabel.isHidden = false
        badgeLabel.text = "\(badge)"
        if badgeTopConstraint != nil {
            let size = badgeLabel.sizeThatFits(CGSize(width: 100, height: 100))
            // Label 宽度
            let w = max(14, size.width.ceiled + 7)
            // Label 高度
            let h = max(14, size.height.ceiled)
            // Label 高度的一半
            let offset = h / 2
            badgeWidthConstraint?.constant = w
            badgeHeightConstraint?.constant = h
            // Label 上边 到 Button 上边的间距
            badgeTopConstraint?.constant = -offset + badgeOffset.y
            // Label 右边 到 Button 右边的间距
            badgeRightConstraint?.constant = w / 2 + badgeOffset.x
            badgeLabel.layer.cornerRadius = offset
            setNeedsUpdateConstraints()
        }
    }
}
#endif // os(iOS)
