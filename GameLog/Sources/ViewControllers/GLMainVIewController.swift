//
//  GLMainVIewController.swift
//  GameLog
//
//  Created by duckbok on 2021/09/13.
//

import UIKit

class GLMainViewController: UIViewController {

    private enum Style {
        enum UserButton {
            static let edgeInsets: NSDirectionalEdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: -16)
            static let placeholderName: String = "person.crop.circle"
            static let size: CGFloat = 40
        }
    }

    var tabBarInfo: GLTabBarController.TabBarInfo {
        return ("", "")
    }

    private lazy var userButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(showSettingViewController), for: .touchUpInside)
        button.layer.cornerRadius = Style.UserButton.size / 2
        button.layer.masksToBounds = true
        button.setImage(UIImage(systemName: Style.UserButton.placeholderName), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: Style.UserButton.size), forImageIn: .normal)
        button.tintColor = Global.Style.mainColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initializer

    init() {
        super.init(nibName: nil, bundle: nil)
        configureAttributes()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - View Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        configureUserButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        userButton.isHidden = false
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userButton.isHidden = true
    }

    // MARK: - Configure

    private func configureAttributes() {
        title = tabBarInfo.title
        tabBarItem.image = UIImage(systemName: tabBarInfo.imageName)
        view.backgroundColor = .systemBackground
    }

    private func configureUserButton() {
        guard let navigationController = navigationController,
              let classType = NSClassFromString("_UINavigationBarLargeTitleView") else { return }

        for subView in navigationController.navigationBar.subviews where subView.isKind(of: classType) {
            guard let largeTitleLabel = subView.subviews.first as? UILabel else { return }

            subView.addSubview(userButton)
            NSLayoutConstraint.activate([
                userButton.centerYAnchor.constraint(equalTo: largeTitleLabel.centerYAnchor),
                userButton.trailingAnchor.constraint(equalTo: subView.trailingAnchor,
                                                     constant: Style.UserButton.edgeInsets.trailing),
                userButton.widthAnchor.constraint(equalToConstant: Style.UserButton.size),
                userButton.heightAnchor.constraint(equalTo: userButton.widthAnchor)
            ])
        }
    }

    // MARK: - Action

    @objc private func showSettingViewController() {
        let settingViewController = SettingViewController()
        let containerViewController = UINavigationController(rootViewController: settingViewController)
        present(containerViewController, animated: true)
    }
}
