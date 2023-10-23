#if canImport(UIKit)

import UIKit

extension UIViewController {
    @inlinable
    public func adjustsContentInsets(_ adjusts: Bool, for view: UIScrollView) {
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = adjusts ? .automatic : .never
        } else {
            automaticallyAdjustsScrollViewInsets = adjusts
        }
    }
}

#endif // canImport(UIKit)
