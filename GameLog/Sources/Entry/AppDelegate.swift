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
        testLogin()
        return true
    }

    private func testLogin() {
        UserService.shared.login(email: "test@gmail.com", password: "123456") { result in
            switch result {
            case let .success(message):
                if let message = message {
                    print(message)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
