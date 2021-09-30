//
//  GameCell.swift
//  GameLog
//
//  Created by duckbok on 2021/09/16.
//

import UIKit

class GameCell: UICollectionViewCell {

    static let reuseIdentifier: String = String(describing: GameCell.self)

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
