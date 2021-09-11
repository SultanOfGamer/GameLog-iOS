//
//  GLTabBarController.swift
//  GameLog
//
//  Created by duckbok on 2021/09/06.
//

import UIKit

final class GLTabBarController: UITabBarController {
    typealias TabBarInfo = (title: String, imageName: String)

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .systemIndigo
        setViewControllers([
            navigationController(with: HomeViewController(), to: HomeViewController.tabBarInfo),
            navigationController(with: LibraryViewController(), to: LibraryViewController.tabBarInfo),
            navigationController(with: WishlistViewController(), to: WishlistViewController.tabBarInfo),
            navigationController(with: SearchViewController(), to: SearchViewController.tabBarInfo)
        ], animated: false)
    }

    private func navigationController(with viewController: UIViewController,
                                      to tabBarInfo: TabBarInfo) -> UINavigationController {
        viewController.title = tabBarInfo.title
        viewController.tabBarItem.image = UIImage(systemName: tabBarInfo.imageName)
        viewController.navigationItem.largeTitleDisplayMode = .always
        viewController.view.backgroundColor = .systemBackground

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        return navigationController
    }
}
