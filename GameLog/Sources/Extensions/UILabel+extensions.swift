//
//  UILabel+extensions.swift
//  GameLog
//
//  Created by duckbok on 2021/10/05.
//

import UIKit

extension UILabel {

    convenience init(textStyle: UIFont.TextStyle) {
        self.init()
        font = .preferredFont(forTextStyle: textStyle)
    }
}
