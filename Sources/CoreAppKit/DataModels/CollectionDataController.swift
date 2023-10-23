#if os(iOS)
import UIKit
import CoreSwift

public protocol CollectionCell {
    func reloadData(_ data: CollectionCellModel)
}

open class CollectionCellModel: Identified, Equatable {
    open var size = CGSize.zero

    open var id: String {
        "UICollectionViewCell"
    }

    public init() {
        // Do nothing.
    }
    
    public static func ==(lhs: CollectionCellModel, rhs: CollectionCellModel) -> Bool {
        return lhs === rhs
    }
    
    public static func ~=(lhs: CollectionCellModel, rhs: CollectionCellModel) -> Bool {
        return lhs === rhs
    }
}

public protocol CollectionReusableView {
    func reloadData(_ data: CollectionViewModel)
}

open class CollectionViewModel: Identified, Equatable {
    open var size = CGSize.zero
    
    open var id: String {
        "UICollectionReusableView"
    }
    
    public init() {
        // Do nothing.
    }
    
    public static func ==(lhs: CollectionViewModel, rhs: CollectionViewModel) -> Bool {
        return lhs === rhs
    }
    
    public static func ~=(lhs: CollectionViewModel, rhs: CollectionViewModel) -> Bool {
        return lhs === rhs
    }
}

@frozen
public struct CollectionSectionModel {
    public var items: [CollectionCellModel]
    public var header: CollectionViewModel?
    public var footer: CollectionViewModel?

    public var insets = UIEdgeInsets.zero

    @inlinable
    public init(
        items: [CollectionCellModel] = [],
        header: CollectionViewModel? = nil,
        footer: CollectionViewModel? = nil
    ) {
        self.items = items
        self.header = header
        self.footer = footer
    }

    @inlinable
    public var isEmpty: Bool {
        items.isEmpty
    }

    @inlinable
    public var count: Int {
        items.count
    }

    @inlinable
    public func item(at index: Int) -> CollectionCellModel? {
        items.at(index)
    }
}

@frozen
public struct CollectionMapModel {
    public var sections: [CollectionSectionModel]

    @inlinable
    public init(sections: [CollectionSectionModel] = []) {
        self.sections = sections
    }

    @inlinable
    public var isEmpty: Bool {
        sections.isEmpty
    }

    @inlinable
    public var count: Int {
        sections.count
    }

    @inlinable
    public func section(at index: Int) -> CollectionSectionModel? {
        sections.at(index)
    }

    @inlinable
    public func item(at indexPath: IndexPath) -> CollectionCellModel? {
        section(at: indexPath.section)?.item(at: indexPath.row)
    }

    @inlinable
    public func itemCount(in section: Int) -> Int {
        sections.at(section)?.count ?? 0
    }

    @inlinable
    public func header(in section: Int) -> CollectionViewModel? {
        sections.at(section)?.header
    }

    @inlinable
    public func header(at indexPath: IndexPath) -> CollectionViewModel? {
        header(in: indexPath.section)
    }

    @inlinable
    public func footer(in section: Int) -> CollectionViewModel? {
        sections.at(section)?.footer
    }

    @inlinable
    public func footer(at indexPath: IndexPath) -> CollectionViewModel? {
        footer(in: indexPath.section)
    }
}

open class CollectionDataController: Registrable {
    public internal(set) var currentMap: CollectionMapModel

    public init() {
        currentMap = CollectionMapModel()
    }

    @inlinable
    public final var isEmpty: Bool {
        currentMap.isEmpty
    }

    @inlinable
    public final var count: Int {
        currentMap.count
    }

    @inlinable
    public final var totalCount: Int {
        currentMap.sections.reduce(0) { result, next in
            result + next.count
        }
    }

    open func update(to map: CollectionMapModel) {
        currentMap = map
    }

    @inlinable
    public final func section(at index: Int) -> CollectionSectionModel {
        currentMap.section(at: index) ?? CollectionSectionModel()
    }

    @inlinable
    public final func item(at indexPath: IndexPath) -> CollectionCellModel {
        currentMap.item(at: indexPath) ?? CollectionCellModel()
    }

    public final func supplementaryView(at indexPath: IndexPath, of kind: String) -> CollectionViewModel {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return currentMap.header(at: indexPath) ?? CollectionViewModel()
        case UICollectionView.elementKindSectionFooter:
            return currentMap.footer(at: indexPath) ?? CollectionViewModel()
        default:
            return CollectionViewModel()
        }
    }

    public final func indexPath(of item: CollectionCellModel) -> IndexPath? {
        var s: Int = 0
        for section in currentMap.sections {
            let row = section.items.firstIndex { model in
                model === item
            }
            if let r = row {
                return IndexPath(row: r, section: s)
            }
            s += 1
        }
        return nil
    }

    public final func itemCount(in section: Int) -> Int {
        currentMap.itemCount(in: section)
    }

    public final func header(in section: Int) -> CollectionViewModel {
        currentMap.header(in: section) ?? CollectionViewModel()
    }

    public final func header(at indexPath: IndexPath) -> CollectionViewModel {
        currentMap.header(at: indexPath) ?? CollectionViewModel()
    }

    public final func footer(in section: Int) -> CollectionViewModel {
        currentMap.footer(in: section) ?? CollectionViewModel()
    }

    public final func footer(at indexPath: IndexPath) -> CollectionViewModel {
        currentMap.footer(at: indexPath) ?? CollectionViewModel()
    }

    public final func dequeueCell(using collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        let model = item(at: indexPath)
        return collectionView.dequeueReusableCell(withReuseIdentifier: model.id, for: indexPath)
    }

    public final func dequeueSupplementaryView(using collectionView: UICollectionView, of kind: String,
        for indexPath: IndexPath) -> UICollectionReusableView {
        let model = supplementaryView(at: indexPath, of: kind)
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
            withReuseIdentifier: model.id, for: indexPath)
    }

    open class func register(to target: UICollectionView) {
        target.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        target.register(UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "UICollectionReusableView")
        target.register(UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "UICollectionReusableView")
    }
}
#endif // os(iOS)

