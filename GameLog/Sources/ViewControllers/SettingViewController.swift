//
//  SettingViewController.swift
//  GameLog
//
//  Created by duckbok on 2021/10/24.
//

import UIKit

final class SettingViewController: UIViewController {

    // MARK: - Initializer

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "설정"
        view.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        return nil
    }
}
