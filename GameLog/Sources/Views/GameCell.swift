//
//  GameCell.swift
//  GameLog
//
//  Created by duckbok on 2021/09/16.
//

import UIKit

class GameCell: UICollectionViewCell {

    static let reuseIdentifier: String = String(describing: GameCell.self)

    var dataTask: URLSessionDataTask?

    var game: Section.Game? {
        didSet {
            if let game = game,
               let coverURL = URL(string: game.cover.url) {
                dataTask = URLSession.shared.dataTask(with: coverURL) { [weak self] (data, _, _) in
                    guard let data = data,
                          let image = UIImage(data: data) else { return }

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
        coverImageView.image = nil
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
