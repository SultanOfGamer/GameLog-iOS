//
//  UIActivityIndicatorView+loading.swift
//  GameLog
//
//  Created by duckbok on 2021/10/15.
//

import UIKit

extension UIActivityIndicatorView {

    convenience init(style: Style, color: UIColor) {
        self.init(style: style)
        self.color = color
        translatesAutoresizingMaskIntoConstraints = false
    }

    func startLoading(to view: UIView) {
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        view.isHidden = true
        startAnimating()
    }

    func stopLoading(to view: UIView) {
        view.isHidden = false
        stopAnimating()
    }
}
