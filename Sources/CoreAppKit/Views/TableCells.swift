#if os(iOS)
import UIKit

public final class DefaultTableCell: RegistrableTableViewCell, TableCell {
    public typealias Target = UITableView
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: CellStyle.default, reuseIdentifier: reuseIdentifier)
        initialization()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }

    private func initialization() {
        backgroundColor = UIColor.white
        selectionStyle = .none
    }

    public func reloadData(_ data: TableCellModel) {
        guard let model = data as? DefaultTableCellModel else {
            return
        }
        backgroundColor = model.backgroundColor
        accessoryType = model.accessory
        textLabel?.attributedText = model.title
        detailTextLabel?.attributedText = model.text
        imageView?.image = model.image
    }
}

public final class SubtitleTableCell: RegistrableTableViewCell, TableCell {
    public typealias Target = UITableView
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        initialization()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }

    private func initialization() {
        backgroundColor = UIColor.white
        selectionStyle = .none
    }

    public func reloadData(_ data: TableCellModel) {
        guard let model = data as? DefaultTableCellModel else {
            return
        }
        backgroundColor = model.backgroundColor
        accessoryType = model.accessory
        textLabel?.attributedText = model.title
        detailTextLabel?.attributedText = model.text
        imageView?.image = model.image
    }
}

public final class Value1TableCell: RegistrableTableViewCell, TableCell {
    public typealias Target = UITableView
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: CellStyle.value1, reuseIdentifier: reuseIdentifier)
        initialization()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }

    private func initialization() {
        backgroundColor = UIColor.white
        selectionStyle = .none
    }

    public func reloadData(_ data: TableCellModel) {
        guard let model = data as? DefaultTableCellModel else {
            return
        }
        backgroundColor = model.backgroundColor
        accessoryType = model.accessory
        textLabel?.attributedText = model.title
        detailTextLabel?.attributedText = model.text
        imageView?.image = model.image
    }
}

public final class Value2TableCell: RegistrableTableViewCell, TableCell {
    public typealias Target = UITableView
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: CellStyle.value2, reuseIdentifier: reuseIdentifier)
        initialization()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }

    private func initialization() {
        backgroundColor = UIColor.white
        selectionStyle = .none
    }

    public func reloadData(_ data: TableCellModel) {
        guard let model = data as? DefaultTableCellModel else {
            return
        }
        backgroundColor = model.backgroundColor
        accessoryType = model.accessory
        textLabel?.attributedText = model.title
        detailTextLabel?.attributedText = model.text
        imageView?.image = model.image
    }
}

open class DefaultTableCellModel: TableCellModel {
    public typealias Target = UITableView
    
    public let style: UITableViewCell.CellStyle
    public var backgroundColor = UIColor.white
    public var accessory = UITableViewCell.AccessoryType.none
    public var title: NSAttributedString?
    public var text: NSAttributedString?
    public var image: UIImage?

    public init(style: UITableViewCell.CellStyle) {
        self.style = style
        super.init()
    }

    open override var id: String {
        switch style {
        case .value1:
            return Value1TableCell.id
        case .value2:
            return Value2TableCell.id
        case .subtitle:
            return SubtitleTableCell.id
        case .default:
            fallthrough
        @unknown default:
            return DefaultTableCell.id
        }
    }
}
#endif // os(iOS)
