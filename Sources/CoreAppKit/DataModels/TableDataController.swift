#if os(iOS)
import UIKit

public protocol TableCell {
    func reloadData(_ data: TableCellModel)
}

open class TableCellModel: Identified, Equatable {
    open var height: CGFloat

    open var id: String {
        "UITableViewCell"
    }

    public init(height: CGFloat = 44) {
        self.height = height
    }
    
    public static func ==(lhs: TableCellModel, rhs: TableCellModel) -> Bool {
        return lhs === rhs
    }
    
    public static func ~=(lhs: TableCellModel, rhs: TableCellModel) -> Bool {
        return lhs === rhs
    }
}

public protocol TableReusableView {
    func reloadData(_ data: TableViewModel)
}

open class TableViewModel: Identified, Equatable {
    open var height: CGFloat = 0

    open var id: String {
        "UITableViewHeaderFooterView"
    }

    public init() {
        // Do nothing
    }
    
    public static func ==(lhs: TableViewModel, rhs: TableViewModel) -> Bool {
        lhs === rhs
    }

    public static func ~=(lhs: TableViewModel, rhs: TableViewModel) -> Bool {
        lhs === rhs
    }
}

@frozen
public struct TableSectionModel {
    public var items: [TableCellModel]
    public var header: TableViewModel?
    public var footer: TableViewModel?

    public var topInset: CGFloat?
    public var bottomInset: CGFloat?

    public init(items: [TableCellModel] = [], header: TableViewModel? = nil, footer: TableViewModel? = nil) {
        self.items = items
        self.header = header
        self.footer = footer
    }

    public var isEmpty: Bool {
        items.isEmpty
    }

    public var count: Int {
        items.count
    }

    public var headerHeight: CGFloat? {
        header?.height ?? topInset
    }

    public var footerHeight: CGFloat? {
        footer?.height ?? bottomInset
    }

    public func item(at index: Int) -> TableCellModel? {
        items.at(index)
    }
}

@frozen
public struct TableMapModel {
    public var sections: [TableSectionModel]

    public init(sections: [TableSectionModel] = []) {
        self.sections = sections
    }

    public var isEmpty: Bool {
        sections.isEmpty
    }

    public var count: Int {
        sections.count
    }

    public func section(at index: Int) -> TableSectionModel? {
        sections.at(index)
    }

    public func item(at indexPath: IndexPath) -> TableCellModel? {
        section(at: indexPath.section)?.item(at: indexPath.row)
    }

    public func itemCount(in section: Int) -> Int {
        sections.at(section)?.count ?? 0
    }

    public func header(in section: Int) -> TableViewModel? {
        sections.at(section)?.header
    }

    public func header(at indexPath: IndexPath) -> TableViewModel? {
        header(in: indexPath.section)
    }

    public func footer(in section: Int) -> TableViewModel? {
        sections.at(section)?.footer
    }

    public func footer(at indexPath: IndexPath) -> TableViewModel? {
        footer(in: indexPath.section)
    }
}

open class TableDataController: Registrable {
    public private(set) var currentMap: TableMapModel

    public init() {
        currentMap = TableMapModel()
    }

    public final var isEmpty: Bool {
        currentMap.isEmpty
    }

    public final var count: Int {
        currentMap.count
    }

    public final var totalCount: Int {
        currentMap.sections.reduce(0) { result, next in
            result + next.count
        }
    }

    open func update(to map: TableMapModel) {
        currentMap = map
    }

    public final func section(at index: Int) -> TableSectionModel {
        currentMap.section(at: index) ?? TableSectionModel()
    }

    public final func item(at indexPath: IndexPath) -> TableCellModel {
        currentMap.item(at: indexPath) ?? TableCellModel()
    }

    public final func itemCount(in section: Int) -> Int {
        currentMap.itemCount(in: section)
    }

    public final func header(in section: Int) -> TableViewModel {
        currentMap.header(in: section) ?? TableViewModel()
    }

    public final func header(at indexPath: IndexPath) -> TableViewModel {
        currentMap.header(at: indexPath) ?? TableViewModel()
    }

    public final func footer(in section: Int) -> TableViewModel {
        currentMap.footer(in: section) ?? TableViewModel()
    }

    public final func footer(at indexPath: IndexPath) -> TableViewModel {
        currentMap.footer(at: indexPath) ?? TableViewModel()
    }

    public final func headerHeight(in section: Int) -> CGFloat {
        self.section(at: section).headerHeight ?? 0
    }

    public final func footerHeight(in section: Int) -> CGFloat {
        self.section(at: section).footerHeight ?? 0
    }

    public final func dequeueCell(using tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let model = item(at: indexPath)
        return tableView.dequeueReusableCell(withIdentifier: model.id, for: indexPath)
    }

    public final func dequeueHeaderView(using tableView: UITableView, in section: Int) -> UITableViewHeaderFooterView? {
        let model = self.section(at: section)
        guard let header = model.header else {
            return nil
        }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: header.id)
    }

    public final func dequeueFooterView(using tableView: UITableView, in section: Int) -> UITableViewHeaderFooterView? {
        let model = self.section(at: section)
        guard let footer = model.footer else {
            return nil
        }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: footer.id)
    }

    open class func register(to target: UITableView) {
        target.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        target.register(UITableViewHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
        DefaultTableCell.register(to: target)
        SubtitleTableCell.register(to: target)
        Value1TableCell.register(to: target)
        Value2TableCell.register(to: target)
    }
}
#endif // os(iOS)
