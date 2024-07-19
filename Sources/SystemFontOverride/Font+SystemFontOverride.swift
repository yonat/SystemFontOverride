//
//  Font+SystemFontOverride.swift
//
//  Created by Yonat Sharon on 19/07/2024.
//

import SwiftUI

public extension Font {
    static func systemOverride(size: CGFloat, weight: Weight? = nil, design: Design? = nil) -> Font {
        switch design {
        case .default, nil:
            Font(UIFont.systemFontOverride(size: size, weight: weight?.uiValue))
        default:
            system(size: size, weight: weight ?? .regular, design: design ?? .default)
        }
    }

    static func systemOverride(_ style: Font.TextStyle, design: Font.Design? = nil) -> Font {
        switch design {
        case .default, nil:
            Font(UIFont.systemFontOverride(textStyle: style.uiValue))
        default:
            system(style, design: design ?? .default)
        }
    }
}

private extension Font.Weight {
    var uiValue: UIFont.Weight {
        switch self {
        case .black:
            .black
        case .bold:
            .bold
        case .heavy:
            .heavy
        case .light:
            .light
        case .medium:
            .medium
        case .regular:
            .regular
        case .semibold:
            .semibold
        case .thin:
            .thin
        case .ultraLight:
            .ultraLight
        default:
            .regular
        }
    }
}

private extension Font.TextStyle {
    var uiValue: UIFont.TextStyle {
        switch self {
        case .extraLargeTitle2:
            if #available(iOS 17.0, *) {
                .extraLargeTitle2
            } else {
                .largeTitle
            }
        case .extraLargeTitle:
            if #available(iOS 17.0, *) {
                .extraLargeTitle
            } else {
                .largeTitle
            }
        case .largeTitle:
            .largeTitle
        case .title:
            .title1
        case .title2:
            .title2
        case .title3:
            .title3
        case .headline:
            .headline
        case .subheadline:
            .subheadline
        case .body:
            .body
        case .callout:
            .callout
        case .caption:
            .caption1
        case .caption2:
            .caption2
        case .footnote:
            .footnote
        @unknown default:
            .body
        }
    }
}
