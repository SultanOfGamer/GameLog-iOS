//
//  SearchCell.swift
//  GameLog
//
//  Created by duckbok on 2021/10/20.
//

import UIKit

final class SearchCell: UICollectionViewCell {

    static let reuseIdentifier: String = String(describing: SearchCell.self)

    var dataTask: URLSessionDataTask?

    var game: Search.Game? {
        didSet {
            if let game = game {
                titleLabel.text = game.name
                dataTask = NetworkRepository.fetchImage(from: game.cover.url) { [weak self] image in
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
        imageView.contentMode = .scaleAspectFill
        imageView.image = Global.coverPlaceholder
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCoverImageView()
        configureTitleLable()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - View Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = Global.coverPlaceholder
        titleLabel.text = nil
        dataTask?.cancel()
        dataTask = nil
    }

    // MARK: - Configure

    private func configureCoverImageView() {
        contentView.addSubview(coverImageView)
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor)
        ])
    }

    private func configureTitleLable() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
