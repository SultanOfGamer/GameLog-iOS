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

    private var profile: Profile?
    private var profileImage: UIImage? {
        didSet {
            if let profileImage = profileImage {
                userButton.layer.borderWidth = 2
                userButton.setImage(profileImage, for: .normal)
            } else {
                userButton.layer.borderWidth = 0
                userButton.setImage(UIImage(systemName: Style.UserButton.placeholderName), for: .normal)
            }
        }
    }

    private lazy var userButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(showSettingViewController), for: .touchUpInside)
        button.layer.borderColor = Global.Style.mainColor.cgColor
        button.layer.cornerRadius = Style.UserButton.size / 2
        button.layer.masksToBounds = true
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

    override func viewDidLoad() {
        super.viewDidLoad()
        UserService.testLogin {
            self.fetchProfile()
        }
    }

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

    private func fetchProfile() {
        profileImage = nil
        UserService.shared.profile { [weak self] result in
            guard let self = self,
                  let profile = try? result.get() else { return }
            self.profile = profile
            if let profileImagePath = profile.profileImagePath {
                UserService.shared.profileImage(path: profileImagePath) { image in
                    DispatchQueue.main.async {
                        self.profileImage = image
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.profileImage = nil
                }
            }
        }
    }

    // MARK: - Action

    @objc private func showSettingViewController() {
        guard let profile = profile else { return }

        let settingViewController = SettingViewController(profile: profile, profileImage: profileImage)
        let containerViewController = UINavigationController(rootViewController: settingViewController)
        present(containerViewController, animated: true)
    }
}
