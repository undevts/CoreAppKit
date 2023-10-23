#if canImport(UIKit)
import UIKit
#endif

public protocol Registrable {
    associatedtype Target

    static func register(to target: Target)
}

#if canImport(UIKit)
public protocol TableRegistrable: Registrable, StaticIdentified where Target: UITableView {}

extension TableRegistrable where Target == UITableView, Self: UITableViewCell {
    public static var id: String {
        String(describing: self)
    }
    
    public static func register(to target: UITableView) {
        target.register(Self.self, forCellReuseIdentifier: Self.id)
    }
}

public protocol CollectionRegistrable: Registrable, StaticIdentified where Target: UICollectionView {}

extension CollectionRegistrable where Target == UICollectionView, Self: UICollectionViewCell {
    public static var id: String {
        String(describing: self)
    }
    
    public static func register(to target: UICollectionView) {
        target.register(Self.self, forCellWithReuseIdentifier: Self.id)
    }
}

extension CollectionRegistrable where Target == UICollectionView, Self: UICollectionReusableView {
    public static var id: String {
        String(describing: self)
    }
    
    public static func register(to target: UICollectionView) {
        target.register(Self.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: Self.id)
        target.register(Self.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                        withReuseIdentifier: Self.id)
    }
}

public typealias RegistrableCollectionViewCell = CollectionRegistrable & UICollectionViewCell
public typealias RegistrableTableViewCell = TableRegistrable & UITableViewCell
#endif // canImport(UIKit)
