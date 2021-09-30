//
//  GLTabBarController.swift
//  GameLog
//
//  Created by duckbok on 2021/09/06.
//

import UIKit

final class GLTabBarController: UITabBarController {

    typealias TabBarInfo = (title: String, imageName: String)

    // MARK: - Initializer

    init() {
        super.init(nibName: nil, bundle: nil)
        tabBar.tintColor = GameLog.Style.mainColor
        setViewControllers([
            navigationController(with: HomeViewController()),
            navigationController(with: LibraryViewController()),
            navigationController(with: WishlistViewController()),
            navigationController(with: SearchViewController())
        ], animated: false)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Configure

    private func navigationController(with viewController: GLMainViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        return navigationController
    }
}
