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
            static let topInset: CGFloat = -44
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

    let screenshotImageView = UIImageView()
    let coverImageView = UIImageView()

    let statusLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Global.Style.mainColor
        label.font = .preferredFont(forTextStyle: .footnote, weight: .bold)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }()

    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()

    let aggregatedLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = Global.Style.mainColor
        return label
    }()

    let labelStackView = UIStackView()

    // MARK: - Initializer

    init() {
        realBottomAnchor = coverImageView.bottomAnchor
        super.init(frame: .zero)
        configureScreenshotImageView()
        configureCoverImageView()
        configureStatusLabel()
        configureLabelStackView()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - Configure

    private func configureScreenshotImageView() {
        screenshotImageView.clipsToBounds = true
        screenshotImageView.contentMode = .scaleAspectFill
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
    }

    private func configureStatusLabel() {
        addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: -8),
            statusLabel.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor),
            statusLabel.widthAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: 0.8)
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
        labelStackView.addArrangedSubview(aggregatedLabel)
    }

    func setBasicData(name: String?, cover: UIImage?) {
        coverImageView.image = cover ?? Global.coverPlaceholder
        screenshotImageView.image = Global.screenshotPlaceholder
        titleLabel.text = name
        releaseDateLabel.text = " "
        aggregatedLabel.text = " "
    }
}
