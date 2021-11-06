//
//  GameCell.swift
//  GameLog
//
//  Created by duckbok on 2021/09/16.
//

import UIKit

final class GameCell: UICollectionViewCell {

    static let reuseIdentifier: String = String(describing: GameCell.self)

    var dataTask: URLSessionDataTask?

    var game: Section.Game? {
        didSet {
            if let cover = game?.cover {
                dataTask = NetworkRepository.fetchImage(from: cover.url) { [weak self] image in
                    DispatchQueue.main.async {
                        self?.coverImageView.image = image
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

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCoverImageView()
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
}
