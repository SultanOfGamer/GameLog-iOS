//
//  HomeViewController.swift
//  GameLog
//
//  Created by duckbok on 2021/08/23.
//

import UIKit

final class HomeViewController: GLMainViewController {

    override var tabBarInfo: GLTabBarController.TabBarInfo {
        return ("홈", "house.fill")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
