//
//  UIView+shadow.swift
//  GameLog
//
//  Created by duckbok on 2021/10/05.
//

import UIKit

extension UIView {

    func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
    }
}
