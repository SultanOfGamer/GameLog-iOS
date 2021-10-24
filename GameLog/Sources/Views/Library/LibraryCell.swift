//
//  LibraryCell.swift
//  GameLog
//
//  Created by duckbok on 2021/10/13.
//

import UIKit

class LibraryCell: UICollectionViewCell {

    static let reuseIdentifier: String = String(describing: LibraryCell.self)

    var dataTask: URLSessionDataTask?

    var game: Library.Game? {
        didSet {
            if let game = game {
                dataTask = NetworkRepository.fetchImage(from: game.cover.url) { [weak self] image in
                    DispatchQueue.main.async {
                        self?.coverImageView.image = image

                        if game.userGameStatus != .wish {
                            self?.statusLabel.text = game.userGameStatus?.rawValue.uppercased()
                        }
                    }
                }
                dataTask?.resume()
            }
        }
    }

    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Global.coverPlaceholder
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let statusLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Global.Style.mainColor
        label.font = .preferredFont(forTextStyle: .body, weight: .bold)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCoverImageView()
        configureStatusLabel()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - View Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = Global.coverPlaceholder
        dataTask?.cancel()
        dataTask = nil
    }

    // MARK: - Configure

    private func configureCoverImageView() {
        contentView.addSubview(coverImageView)
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func configureStatusLabel() {
        contentView.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -5),
            statusLabel.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor),
            statusLabel.widthAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: 0.8)
        ])
    }
}
