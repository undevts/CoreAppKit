#if canImport(UIKit)

import UIKit

public final class Screens {
    private static var cachedSize = CGSize(width: 0.0, height: 0.0)
    
    @available(iOS 13.0, *)
    public static var currentScene: UIWindowScene? {
        UIApplication.shared.connectedScenes.firstOf { scene in
            return if scene.activationState == .foregroundActive {
                scene as? UIWindowScene
            } else {
                nil
            }
        }
    }
    
    public static var currentWindow: UIWindow? {
        return if #available(iOS 15.0, *) {
            currentScene?.keyWindow ?? UIApplication.shared.keyWindow
        } else if #available(iOS 13.0, *) {
            currentScene?.windows.first { window in
                window.isKeyWindow
            } ?? UIApplication.shared.keyWindow
        } else {
            UIApplication.shared.keyWindow
        }
    }
    
    public static var currentWidth: CGFloat {
        if pthread_main_np() == 1 {
            fetchSize()
        }
        return cachedSize.width
    }
    
    public static var currentHeight: CGFloat {
        if pthread_main_np() == 1 {
            fetchSize()
        }
        return cachedSize.width
    }
    
    public static var currentSize: (width: CGFloat, height: CGFloat) {
        if pthread_main_np() == 1 {
            fetchSize()
        }
        return (cachedSize.width, cachedSize.height)
    }
    
    private static func fetchSize() {
        cachedSize = currentWindow?.bounds.size ?? CGSize.zero
    }
}

#endif // canImport(UIKit)
