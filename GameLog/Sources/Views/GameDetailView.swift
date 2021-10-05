//
//  GameDetailView.swift
//  GameLog
//
//  Created by duckbok on 2021/10/04.
//

import UIKit

final class GameDetailView: UIView {

    private enum Style {
        static let screenshotImageViewSizeRatio: CGFloat = 0.5625

        enum CoverImageView {
            static let topInset: CGFloat = -50
            static let leadingInset: CGFloat = 16
            static let widthRatio: CGFloat = 0.25
            static let heightRatio: CGFloat = 1.4
        }

        enum LabelStackView {
            static let spacing: CGFloat = 2
            static let leadingInset: CGFloat = 10
            static let trailingInset: CGFloat = -16
            static let bottomInset: CGFloat = -5
        }
    }

    let realBottomAnchor: NSLayoutYAxisAnchor

    // MARK: - View

    private let screenshotImageView = UIImageView()
    private let coverImageView = UIImageView()
    private let titleLabel = UILabel(textStyle: .title3)
    private let releaseDateLabel = UILabel(textStyle: .caption1)
    private let aggregatedRatingLabel = UILabel(textStyle: .caption1)
    private let labelStackView = UIStackView()

    // MARK: - Initializer

    init(game: Game) {
        realBottomAnchor = coverImageView.bottomAnchor
        super.init(frame: .zero)
        configureScreenshotImageView(by: game)
        configureCoverImageView(by: game)
        configureLabelStackView()
        setLabelTexts(by: game)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Configure

    private func configureScreenshotImageView(by game: Game) {
        screenshotImageView.contentMode = .scaleAspectFit
        screenshotImageView.image = UIImage(named: game.screenshot)
        screenshotImageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(screenshotImageView)
        NSLayoutConstraint.activate([
            screenshotImageView.topAnchor.constraint(equalTo: topAnchor),
            screenshotImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            screenshotImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            screenshotImageView.heightAnchor.constraint(lessThanOrEqualTo: widthAnchor,
                                                        multiplier: Style.screenshotImageViewSizeRatio)
        ])
    }

    private func configureCoverImageView(by game: Game) {
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.image = UIImage(named: game.cover)
        coverImageView.setShadow()
        coverImageView.layer.masksToBounds = false
        coverImageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(coverImageView)
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: screenshotImageView.bottomAnchor,
                                                constant: Style.CoverImageView.topInset),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: Style.CoverImageView.leadingInset),
            coverImageView.widthAnchor.constraint(equalTo: widthAnchor,
                                                  multiplier: Style.CoverImageView.widthRatio),
            coverImageView.heightAnchor.constraint(lessThanOrEqualTo: coverImageView.widthAnchor,
                                                   multiplier: Style.CoverImageView.heightRatio)
        ])
    }

    private func configureLabelStackView() {
        labelStackView.alignment = .leading
        labelStackView.axis = .vertical
        labelStackView.distribution = .fill
        labelStackView.spacing = Style.LabelStackView.spacing
        labelStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(labelStackView)
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor,
                                                    constant: Style.LabelStackView.leadingInset),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: Style.LabelStackView.trailingInset),
            labelStackView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor,
                                                   constant: Style.LabelStackView.bottomInset)
        ])

        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(releaseDateLabel)
        labelStackView.addArrangedSubview(aggregatedRatingLabel)
    }

    private func setLabelTexts(by game: Game) {
        titleLabel.text = game.name
        releaseDateLabel.text = game.releaseDate.description
        aggregatedRatingLabel.text = "★ \(game.aggregated.rating) (\(game.aggregated.count))"
    }
}
