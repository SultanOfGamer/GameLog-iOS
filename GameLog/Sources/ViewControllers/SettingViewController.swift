//
//  SettingViewController.swift
//  GameLog
//
//  Created by duckbok on 2021/10/24.
//

import UIKit

final class SettingViewController: UIViewController {

    private enum Style {
        static let imageSize: CGFloat = 50
    }

    private var settingContents: [SettingContent.Section]

    private let profile: Profile

    private let settingTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(SettingCell.self, forCellReuseIdentifier: SettingCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Initializer

    init(profile: Profile, profileImage: UIImage?) {
        self.profile = profile
        self.settingContents = SettingContent.contents(nickname: profile.nickname,
                                                       email: profile.email,
                                                       image: profileImage)
        super.init(nibName: nil, bundle: nil)
        title = "설정"
        view.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSettingTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProfileImage()
    }

    // MARK: - Configure

    private func configureSettingTableView() {
        settingTableView.dataSource = self
        settingTableView.delegate = self
        view.addSubview(settingTableView)
        NSLayoutConstraint.activate([
            settingTableView.topAnchor.constraint(equalTo: view.topAnchor),
            settingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func updateProfileImage() {
        guard let profileImagePath = profile.profileImagePath else { return }
        UserService.shared.profileImage(path: profileImagePath) { [weak self] image in
            DispatchQueue.main.async {
                guard image != self?.settingContents.first?.rows.first?.image else { return }

                self?.settingContents[0].rows[0].image = image
                self?.settingTableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingContents.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < settingContents.count else { return 0 }

        return settingContents[section].numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section < settingContents.count,
              let settingCell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier,
                                                              for: indexPath) as? SettingCell else {
                  return SettingCell()
              }

        let settingContent = settingContents[indexPath.section].rows[indexPath.row]
        var content = settingCell.defaultContentConfiguration()
        if indexPath.section == 0 {
            content.image = settingContent.image
            content.imageProperties.maximumSize = CGSize(width: Style.imageSize, height: Style.imageSize)
            content.imageProperties.cornerRadius = Style.imageSize/2
            content.textProperties.font = .preferredFont(forTextStyle: .headline)
            content.secondaryTextProperties.font = .preferredFont(forTextStyle: .subheadline)
        }
        content.text = settingContent.text
        content.secondaryText = settingContent.secondaryText
        settingCell.contentConfiguration = content
        settingCell.accessoryType = settingContent.accessoryType
        return settingCell
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate { }
