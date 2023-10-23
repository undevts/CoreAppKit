#if os(iOS)
import Foundation

#if canImport(UIKit)
import UIKit
#endif

@objc
public enum LigatureLevel: Int {
    case none = 0
    case first = 1
#if os(macOS)
    case second = 2 // Value 2 is unsupported on iOS.
#endif
}

/// A simple wrapper for `NSAttributedString`.
///
/// - See: [NSAttributedString.Key](https://developer.apple.com/documentation/foundation/nsattributedstring/key) .
public final class AttributedBuilder: NSObject {
    let string: NSMutableAttributedString
    public private(set) var attributes: [NSAttributedString.Key: Any]
    public private(set) var wholeRange: NSRange

    @objc
    public init(_ string: String) {
        self.string = NSMutableAttributedString(string: string)
        wholeRange = NSRange(location: 0, length: self.string.length)
        attributes = [:]
    }
    
    init(string: NSMutableAttributedString, attributes: [NSAttributedString.Key: Any], wholeRange: NSRange) {
        self.string = string
        self.attributes = attributes
        self.wholeRange = wholeRange
        super.init()
    }

    @objc
    public override convenience init() {
        self.init("")
    }

    @objc
    public convenience init?(any string: String?) {
        guard let value = string else {
            return nil
        }
        self.init(value)
    }

    @objc
    @discardableResult
    public func setAttribute(key: NSAttributedString.Key, value: Any?) -> AttributedBuilder {
        attributes[key] = value
        if let value = value {
            string.addAttribute(key, value: value, range: wholeRange)
        } else {
            string.removeAttribute(key, range: wholeRange)
        }
        return self
    }

    @objc
    @discardableResult
    @available(*, deprecated, renamed:"append(attributed:)")
    public func append(other: NSAttributedString) -> AttributedBuilder {
        string.append(other)
        wholeRange = NSRange(location: 0, length: string.length)
        return self
    }

    @discardableResult
    @objc(appendString:)
    public func append(string value: String) -> AttributedBuilder {
        string.append(NSAttributedString(string: value))
        wholeRange = NSRange(location: 0, length: string.length)
        return self
    }

    @discardableResult
    @objc(appendAttributedString:)
    public func append(attributed attributedString: NSAttributedString) -> AttributedBuilder {
        string.append(attributedString)
        wholeRange = NSRange(location: 0, length: string.length)
        return self
    }

    @discardableResult
    public func append(_ method: () -> NSAttributedString) -> AttributedBuilder {
        string.append(method())
        wholeRange = NSRange(location: 0, length: string.length)
        return self
    }
    
    @objc
    @discardableResult
    public func append(_ other: AttributedBuilder) -> AttributedBuilder {
        string.append(other.build())
        wholeRange = NSRange(location: 0, length: string.length)
        return self
    }

    @discardableResult
    public func append(_ method: () -> AttributedBuilder) -> AttributedBuilder {
        string.append(method().build())
        wholeRange = NSRange(location: 0, length: string.length)
        return self
    }

    @objc
    @available(*, deprecated, renamed:"build")
    public func done() -> NSMutableAttributedString {
        string
    }

    @objc
    public func build() -> NSAttributedString {
        NSAttributedString(attributedString: string) // Copy
    }

    @objc(buildString:)
    public func build(_ string: String) -> NSMutableAttributedString {
        NSMutableAttributedString(string: string, attributes: attributes)
    }
    
    @objc(copyWithString:)
    public func copy(_ string: String) -> AttributedBuilder {
        let temp = NSMutableAttributedString(string: string, attributes: attributes)
        return AttributedBuilder(string: temp, attributes: attributes, wholeRange: wholeRange)
    }

    @objc
    public static func template() -> AttributedBuilder {
        AttributedBuilder("")
    }
}

@objc
extension AttributedBuilder {
    @discardableResult
    public func attachment(_ value: NSTextAttachment) -> AttributedBuilder {
        setAttribute(key: .attachment, value: value)
    }

    @discardableResult
    public func backgroundColor(_ value: UIColor) -> AttributedBuilder {
        setAttribute(key: .backgroundColor, value: value)
    }

    @discardableResult
    public func backgroundColor(hex: UInt32) -> AttributedBuilder {
        setAttribute(key: .backgroundColor, value: UIColor(argb: hex))
    }

    @discardableResult
    public func baselineOffset(_ value: Double) -> AttributedBuilder {
        setAttribute(key: .baselineOffset, value: NSNumber(value: value))
    }

    @discardableResult
    public func expansion(_ value: Double) -> AttributedBuilder {
        setAttribute(key: .expansion, value: NSNumber(value: value))
    }

    @discardableResult
    public func font(_ value: UIFont) -> AttributedBuilder {
        setAttribute(key: .font, value: value)
    }

    @discardableResult
    public func systemFont(_ size: CGFloat) -> AttributedBuilder {
        setAttribute(key: .font, value: UIFont.systemFont(ofSize: size))
    }

    @discardableResult
    public func systemFont(_ size: CGFloat, weight: UIFont.Weight) -> AttributedBuilder {
        setAttribute(key: .font, value: UIFont.systemFont(ofSize: size, weight: weight))
    }

    @discardableResult
    public func color(_ value: UIColor) -> AttributedBuilder {
        setAttribute(key: .foregroundColor, value: value)
    }

    @discardableResult
    public func color(hex: UInt32) -> AttributedBuilder {
        setAttribute(key: .foregroundColor, value: UIColor(argb: hex))
    }

    @discardableResult
    public func kern(_ value: Double) -> AttributedBuilder {
        setAttribute(key: .kern, value: NSNumber(value: value))
    }

    @discardableResult
    public func ligature(_ value: LigatureLevel) -> AttributedBuilder {
        setAttribute(key: .ligature, value: NSNumber(value: value.rawValue))
    }

    @discardableResult
    public func link(url: URL) -> AttributedBuilder {
        setAttribute(key: .link, value: url)
    }

    @discardableResult
    public func link(_ value: String) -> AttributedBuilder {
        guard let url = URL(string: value) else {
//            Log.error("\(value) is not valid URL")
            return self
        }
        return setAttribute(key: .link, value: url)
    }

    @discardableResult
    public func obliqueness(_ value: Double) -> AttributedBuilder {
        setAttribute(key: .obliqueness, value: NSNumber(value: value))
    }

    @discardableResult
    public func paragraphStyle(_ value: NSParagraphStyle) -> AttributedBuilder {
        setAttribute(key: .paragraphStyle, value: value)
    }

    @discardableResult
    public func shadow(_ value: NSShadow) -> AttributedBuilder {
        setAttribute(key: .shadow, value: value)
    }

    @discardableResult
    public func shadow(offset: CGSize, radius: CGFloat, color: UIColor) -> AttributedBuilder {
        let value = NSShadow()
        value.shadowOffset = offset
        value.shadowBlurRadius = radius
        value.shadowColor = color
        return setAttribute(key: .shadow, value: value)
    }

    @discardableResult
    public func shadow(alpha: CGFloat, blur: CGFloat, x: CGFloat, y: CGFloat, color: UIColor)
            -> AttributedBuilder {
        let value = NSShadow()
        value.shadowOffset = CGSize(width: x, height: y)
        value.shadowBlurRadius = blur
        value.shadowColor = color.withAlphaComponent(alpha)
        return setAttribute(key: .shadow, value: value)
    }

    @discardableResult
    public func shadow(alpha: CGFloat, blur: CGFloat, x: CGFloat, y: CGFloat, hex: UInt32)
            -> AttributedBuilder {
        let value = NSShadow()
        value.shadowOffset = CGSize(width: x, height: y)
        value.shadowBlurRadius = blur
        value.shadowColor = UIColor(argb: hex).withAlphaComponent(alpha)
        return setAttribute(key: .shadow, value: value)
    }

    @discardableResult
    public func strikethroughStyle(_ value: NSUnderlineStyle) -> AttributedBuilder {
        setAttribute(key: .strikethroughStyle, value: NSNumber(value: value.rawValue))
    }

    @discardableResult
    public func strikethroughColor(_ value: UIColor) -> AttributedBuilder {
        setAttribute(key: .strikethroughColor, value: value)
    }

    @discardableResult
    public func strikethroughColor(hex: UInt32) -> AttributedBuilder {
        setAttribute(key: .strikethroughColor, value: UIColor(argb: hex))
    }

    @discardableResult
    public func strokeColor(_ value: UIColor) -> AttributedBuilder {
        setAttribute(key: .strokeColor, value: value)
    }

    @discardableResult
    public func strokeColor(argb hex: UInt32) -> AttributedBuilder {
        setAttribute(key: .strokeColor, value: UIColor(argb: hex))
    }

    @discardableResult
    public func strokeWidth(_ value: Double) -> AttributedBuilder {
        setAttribute(key: .strokeWidth, value: NSNumber(value: value))
    }

    @discardableResult
    public func textEffect(_ value: NSAttributedString.TextEffectStyle) -> AttributedBuilder {
        setAttribute(key: .textEffect, value: value)
    }

    @discardableResult
    public func underlineColor(_ value: UIColor) -> AttributedBuilder {
        setAttribute(key: .underlineColor, value: value)
    }

    @discardableResult
    public func underlineColor(hex: UInt32) -> AttributedBuilder {
        setAttribute(key: .underlineColor, value: UIColor(argb: hex))
    }

    @discardableResult
    public func underlineStyle(_ value: NSUnderlineStyle) -> AttributedBuilder {
        setAttribute(key: .underlineStyle, value: NSNumber(value: value.rawValue))
    }

    @discardableResult
    public func verticalGlyphForm(_ value: Int) -> AttributedBuilder {
        setAttribute(key: .verticalGlyphForm, value: NSNumber(value: value))
    }

    @discardableResult
    public func writingDirection(_ writingDirection: NSWritingDirection,
        text textWritingDirection: NSWritingDirectionFormatType) -> AttributedBuilder {
        setAttribute(key: .writingDirection, value: [writingDirection.rawValue | textWritingDirection.rawValue])
    }
}
#endif // os(iOS)
