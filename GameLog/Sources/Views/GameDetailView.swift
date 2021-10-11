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

    private let game: Game

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
        self.game = game
        super.init(frame: .zero)
        configureScreenshotImageView()
        configureCoverImageView()
        configureLabelStackView()
        setLabelTexts()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Configure

    private func configureScreenshotImageView() {
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

        URLSession.shared.dataTask(with: URL(string: game.screenshot)!) { [weak self] (data, _, _) in
            guard let data = data,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self?.screenshotImageView.image = image
            }
        }.resume()
    }

    private func configureCoverImageView() {
        coverImageView.contentMode = .scaleAspectFit
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

        URLSession.shared.dataTask(with: URL(string: game.cover)!) { [weak self] (data, _, _) in
            guard let data = data,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self?.coverImageView.image = image
            }
        }.resume()
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

    private func setLabelTexts() {
        titleLabel.text = game.name
        releaseDateLabel.text = game.releaseDate.description
        aggregatedRatingLabel.text = "★ \(game.aggregated.rating) (\(game.aggregated.count))"
    }
}
