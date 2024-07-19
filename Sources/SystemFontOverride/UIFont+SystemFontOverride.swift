//
//  UIFont+SystemFontOverride.swift
//
//  Created by Yonat Sharon on 19/07/2024.
//

import UIKit

public extension UIFont {
    /// Override the built-in system font with a different font family.
    ///
    /// Example:
    ///
    ///     UIFont.systemFontFamilyOverride = "Marker Felt"
    static var systemFontFamilyOverride: String? {
        didSet {
            if let systemFontFamilyOverride {
                let fontNames = UIFont.fontNames(forFamilyName: systemFontFamilyOverride)
                assert(!fontNames.isEmpty, "No available fonts in family \(systemFontFamilyOverride)")
            }

            // Prevent method swizzling running twice and reverting to original function
            guard isSwizzled == (systemFontFamilyOverride == nil) else { return }
            isSwizzled.toggle()

            swizzleSystemFontWithOverride()
            UIFontDescriptor.swizzleSystemFontWithOverride()

            UITextView.appearance().setFontFamily(to: systemFontFamilyOverride)
            UISegmentedControl.appearance().setTitleFontFamily(to: systemFontFamilyOverride)
        }
    }
}

// MARK: - Create fonts with overridden font family

public extension UIFont {
    convenience init(family: String, size: CGFloat, italic: Bool = false, weight: UIFont.Weight? = nil, width: UIFont.Width? = nil) {
        var attributes: [UIFontDescriptor.AttributeName: Any] = [.family: family]
        attributes[.traits] = UIFontDescriptor.traits(italic: italic, weight: weight, width: width)
        let descriptor = UIFontDescriptor(fontAttributes: attributes)
        self.init(descriptor: descriptor, size: size)
    }

    static func systemFontOverride(size: CGFloat, italic: Bool = false, weight: UIFont.Weight? = nil, width: UIFont.Width? = nil) -> UIFont {
        guard let systemFontFamilyOverride else {
            if #available(iOS 16.0, *) {
                return systemFont(ofSize: size, weight: weight ?? .regular, width: width ?? .standard)
            } else {
                return systemFont(ofSize: size, weight: weight ?? .regular)
            }
        }
        return UIFont(family: systemFontFamilyOverride, size: size, italic: italic, weight: weight, width: width)
    }

    static func systemFontOverride(textStyle: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection? = nil) -> UIFont {
        guard let systemFontFamilyOverride else {
            return preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection)
        }
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle, compatibleWith: traitCollection)
            .overridingFamily(systemFontFamilyOverride)
        return UIFont(descriptor: descriptor, size: descriptor.pointSize)
    }

    func withFamily(_ family: String?) -> UIFont {
        UIFont(descriptor: fontDescriptor.overridingFamily(family), size: pointSize)
    }
}

private extension UIFontDescriptor {
    /// When withFamily() doesn't work.
    func overridingFamily(_ family: String?) -> UIFontDescriptor {
        guard let family else { return self }
        var attributes: [UIFontDescriptor.AttributeName: Any] = [.family: family]
        attributes[.traits] = fontAttributes[.traits]
        attributes[.size] = fontAttributes[.size]
        return UIFontDescriptor(fontAttributes: attributes)
    }

    static func traits(italic: Bool, weight: UIFont.Weight?, width: UIFont.Width?) -> [UIFontDescriptor.TraitKey: Any]? {
        var traits: [TraitKey: Any] = [:]
        traits[.weight] = weight
        traits[.width] = width
        if italic {
            traits[.slant] = 1.0
        }
        return traits.isEmpty ? nil : traits
    }
}

// MARK: - Utilities

private extension UISegmentedControl {
    func setTitleFontFamily(to newFontFamily: String?, for state: UIControl.State = .normal) {
        if let newFontFamily {
            var titleTextAttributes = titleTextAttributes(for: state) ?? [:]
            let newFont = (titleTextAttributes[.font] as? UIFont)?.withFamily(newFontFamily)
                ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            titleTextAttributes[.font] = newFont
            setTitleTextAttributes(titleTextAttributes, for: state)
        } else {
            if var titleTextAttributes = titleTextAttributes(for: state) {
                titleTextAttributes[.font] = nil
                setTitleTextAttributes(titleTextAttributes, for: state)
            }
        }
    }
}

private extension UITextView {
    func setFontFamily(to newFontFamily: String?) {
        if let newFontFamily {
            font = font?.withFamily(newFontFamily) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        } else {
            font = nil
        }
    }
}

// MARK: - Swizzle system font creation

private extension UIFont {
    static var isSwizzled = false

    @objc class func systemFontOverride(ofSize size: CGFloat) -> UIFont {
        systemFontOverride(size: size)
    }

    @objc class func systemFontOverride(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        systemFontOverride(size: size, weight: weight)
    }

    @objc class func systemFontOverride(ofSize size: CGFloat, weight: UIFont.Weight, width: UIFont.Width) -> UIFont {
        systemFontOverride(size: size, weight: weight, width: width)
    }

    @objc class func boldSystemFontOverride(ofSize size: CGFloat) -> UIFont {
        systemFontOverride(size: size, weight: .bold)
    }

    @objc class func italicSystemFontOverride(ofSize size: CGFloat) -> UIFont {
        systemFontOverride(size: size, italic: true)
    }

    @objc class func monospacedDigitSystemFontOverride(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        systemFontOverride(size: fontSize, weight: weight)
    }

    @objc class func preferredFontOverride(forTextStyle style: UIFont.TextStyle) -> UIFont {
        systemFontOverride(textStyle: style)
    }

    @objc class func preferredFontOverride(forTextStyle style: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection?) -> UIFont {
        systemFontOverride(textStyle: style, compatibleWith: traitCollection)
    }

    static func swizzleSystemFontWithOverride() {
        swizzleClassMethod(#selector(systemFont(ofSize:)), with: #selector(systemFontOverride(ofSize:)))
        swizzleClassMethod(#selector(systemFont(ofSize:weight:)), with: #selector(systemFontOverride(ofSize:weight:)))
        if #available(iOS 16.0, *) {
            swizzleClassMethod(#selector(systemFont(ofSize:weight:width:)), with: #selector(systemFontOverride(ofSize:weight:width:)))
        }
        swizzleClassMethod(#selector(boldSystemFont(ofSize:)), with: #selector(boldSystemFontOverride(ofSize:)))
        swizzleClassMethod(#selector(italicSystemFont(ofSize:)), with: #selector(italicSystemFontOverride(ofSize:)))
        swizzleClassMethod(#selector(monospacedDigitSystemFont(ofSize:weight:)), with: #selector(monospacedDigitSystemFontOverride(ofSize:weight:))) // used in DatePicker numbers
        swizzleClassMethod(#selector(preferredFont(forTextStyle:)), with: #selector(preferredFontOverride(forTextStyle:)))
        swizzleClassMethod(#selector(preferredFont(forTextStyle:compatibleWith:)), with: #selector(preferredFontOverride(forTextStyle:compatibleWith:)))
    }
}

private extension UIFontDescriptor {
    @objc class func preferredFontDescriptorOverride(withTextStyle style: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection?) -> UIFontDescriptor {
        preferredFontDescriptorOverride(withTextStyle: style, compatibleWith: traitCollection) // calls original func
            .overridingFamily(UIFont.systemFontFamilyOverride)
    }

    @objc class func preferredFontDescriptorOverride(withTextStyle style: UIFont.TextStyle) -> UIFontDescriptor {
        preferredFontDescriptorOverride(withTextStyle: style) // calls original func
            .overridingFamily(UIFont.systemFontFamilyOverride)
    }

    static func swizzleSystemFontWithOverride() {
        swizzleClassMethod(#selector(preferredFontDescriptor(withTextStyle:)), with: #selector(preferredFontDescriptorOverride(withTextStyle:)))
        swizzleClassMethod(#selector(preferredFontDescriptor(withTextStyle:compatibleWith:)), with: #selector(preferredFontDescriptorOverride(withTextStyle:compatibleWith:))) // used in DatePicker.datePickerStyle(.graphical)
    }
}

private extension NSObject {
    static func swizzleClassMethod(_ selector: Selector, with newSelector: Selector) {
        if let method = class_getClassMethod(self, selector),
           let newMethod = class_getClassMethod(self, newSelector) {
            method_exchangeImplementations(method, newMethod)
        }
    }
}
