//
//  SettingViewController.swift
//  GameLog
//
//  Created by duckbok on 2021/10/24.
//

import UIKit

final class SettingViewController: UIViewController {

    private let profile: Profile

    private let profileImageView: UIImageView = UIImageView()

    // MARK: - Initializer

    init(profile: Profile, profileImage: UIImage?) {
        self.profile = profile
        self.profileImageView.image = profileImage
        super.init(nibName: nil, bundle: nil)
        title = "설정"
        view.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UserService.shared.profile { result in
            print(result)
        }
    }
}
