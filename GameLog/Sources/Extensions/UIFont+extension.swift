//
//  UIFont+extension.swift
//  GameLog
//
//  Created by duckbok on 2021/10/24.
//

import UIKit

extension UIFont {

    static func preferredFont(forTextStyle style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: UIFont.preferredFont(forTextStyle: style).pointSize, weight: weight)
    }
}
