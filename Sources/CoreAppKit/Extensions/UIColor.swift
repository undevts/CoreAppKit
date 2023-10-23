#if canImport(UIKit)

import UIKit

#endif // canImport(UIKit)

#if canImport(CoreGraphics)

import CoreGraphics

@inline(__always)
private func to(_ value: UInt32) -> CGFloat {
    CGFloat(value) / CGFloat(255.0)
}

#endif // canImport(CoreGraphics)

public enum ColorComponent {
    public static func argb<T>(_ argb: UInt32, make: (UInt32, UInt32, UInt32, UInt32) -> T) -> T {
        let value = argb < 0xFFFF_FFFF ? argb : 0xFFFF_FFFF
        let a: UInt32 = (value > 0x00FF_FFFF) ? ((value & 0xFF00_0000) >> 24) : 0xFF
        let r: UInt32 = (value & 0x00FF_0000) >> 16
        let g: UInt32 = (value & 0x0000_FF00) >> 8
        let b: UInt32 = (value & 0x0000_00FF)
        return make(r, g, b, a)
    }

    public static func rgb<T>(_ rgb: UInt32, make: (UInt32, UInt32, UInt32) -> T) -> T {
        let value = rgb < 0x00FF_FFFF ? rgb : 0x00FF_FFFF
        let r: UInt32 = (value & 0x00FF_0000) >> 16
        let g: UInt32 = (value & 0x0000_FF00) >> 8
        let b: UInt32 = (value & 0x0000_00FF)
        return make(r, g, b)
    }

#if canImport(CoreGraphics)
    public static func argb<T>(floating argb: UInt32, make: (CGFloat, CGFloat, CGFloat, CGFloat) -> T) -> T {
        self.argb(argb) { r, g, b, a in
            make(to(r), to(g), to(b), to(a))
        }
    }

    public static func rgb<T>(floating rgb: UInt32, make: (CGFloat, CGFloat, CGFloat) -> T) -> T {
        self.rgb(rgb) { r, g, b in
            make(to(r), to(g), to(b))
        }
    }
#endif // canImport(CoreGraphics)
}

#if canImport(UIKit)

extension UIColor {
    /// 使用数字生成 UIColor。颜色排序为 A，R，G，B。
    /// 当 value 的值为 0x00_0000 到 0xFF_FFFFF 时，Alpha 解析为 1。
    ///
    /// - Parameter argb: 色值，范围为 0x0000_0000 到 0xFFFF_FFFFF。
    ///
    /// - Note: Objective-C 请使用 `[UIColor argb]`
    @objc
    public convenience init(argb: UInt32) {
        var red = 0 as CGFloat
        var green = 0 as CGFloat
        var blue = 0 as CGFloat
        var alpha = 0 as CGFloat
        ColorComponent.argb(floating: argb) { r, g, b, a in
            red = r
            green = g
            blue = b
            alpha = a
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// 使用数字生成 UIColor。颜色排序为 R，G，B，A。
    ///
    /// - Parameters:
    ///   - rgb: 色值，范围为 0x00_0000 到 0xFF_FFFFF。
    ///   - alpha: 透明度，取值范围为 0 - 1。
    ///
    /// - Note: Objective-C 请使用 `[UIColor rgb:alpha:]`
    @objc
    public convenience init(rgb: UInt32, alpha: CGFloat) {
        var red = 0 as CGFloat
        var green = 0 as CGFloat
        var blue = 0 as CGFloat
        ColorComponent.rgb(floating: rgb) { r, g, b in
            red = r
            green = g
            blue = b
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    ///  使用 String 生成 UIColor。可以接受的格式有：
    /// + FFFFFF
    /// + FFFFFFFF
    /// + #FFFFFF
    /// + #FFFFFFFF
    /// + 0xFFFFFF
    /// + 0xFFFFFFFF
    /// + 0XFFFFFF
    /// + 0XFFFFFFFF
    ///
    /// - Parameter value: 符合上述格式的字符串。
    ///
    ///  - Note: Objective-C 请使用 `[UIColor from:]`
    @objc
    public convenience init(_ value: String) {
        let range = value.range(of: "#") ?? value.range(of: "0x") ??
            value.range(of: "0X")
        let raw: UInt32?
        if let r = range {
            raw = r.lowerBound == value.startIndex ?
                UInt32(value[r.upperBound...], radix: 16) :
                nil // 非开头，非法输入
        } else {
            raw = UInt32(value, radix: 16)
        }
        self.init(argb: raw ?? 0)
    }
}

//extension UIColor: RangeBasedRandom {
//    public typealias Bound = UInt32
//
//    @inline(__always)
//    private static func make(_ argb: UInt32) -> Self {
//        ColorComponent.argb(floating: argb, make: Self.init(red:green:blue:alpha:))
//    }
//
//    @inlinable
//    public static func random() -> Self {
//        Self.random(in: 0x0...0xFFFF_FFFF)
//    }
//
//    public static func random(in range: ClosedRange<Bound>) -> Self {
//        make(UInt32.random(in: range))
//    }
//
//    public static func random(in range: Range<Bound>) -> Self {
//        make(UInt32.random(in: range))
//    }
//
//    public static func random<T>(in range: ClosedRange<Bound>,
//        using generator: inout T) -> Self where T: RandomNumberGenerator {
//        make(UInt32.random(in: range, using: &generator))
//    }
//
//    public static func random<T>(in range: Range<Bound>,
//        using generator: inout T) -> Self where T: RandomNumberGenerator {
//        make(UInt32.random(in: range, using: &generator))
//    }
//}

#endif // canImport(UIKit)
