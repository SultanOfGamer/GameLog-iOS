//
//  AppDelegate.swift
//  GameLog
//
//  Created by duckbok on 2021/08/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.rootViewController = GLTabBarController()
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}
