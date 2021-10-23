//
//  UIViewController+alert.swift
//  GameLog
//
//  Created by duckbok on 2021/10/24.
//

import UIKit

extension UIViewController {

    func presentAlertController(_ alertController: UIAlertController,
                                time: Double = 0.5) {
        present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
