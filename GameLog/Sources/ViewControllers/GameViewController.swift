//
//  GameViewController.swift
//  GameLog
//
//  Created by duckbok on 2021/10/01.
//

import UIKit
import Cosmos

final class GameViewController: UIViewController {

    private enum Style {
        enum StarRatingView {
            static let emptyColor: UIColor = .systemGray3
            static let margin: Double = 5
            static let size: Double = 40
            static let verticalInset: CGFloat = 16
        }

        enum GameStackView {
            static let spacing: CGFloat = 10
            static let horizontalInset: CGFloat = 16
        }

        enum SummaryLabel {
            static let title: String = "소개"
        }

        enum ReviewLabel {
            static let title: String = "리뷰"
            static let placeholder: String = "눌러서 작성하기"
        }
    }

    private var game: Game

    private let gameDetailView: GameDetailView

    private let gameScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let gameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Style.GameStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let starRatingView: CosmosView = {
        let cosmosView = CosmosView()
        cosmosView.rating = 0
        cosmosView.settings.emptyBorderColor = Style.StarRatingView.emptyColor
        cosmosView.settings.emptyColor = Style.StarRatingView.emptyColor
        cosmosView.settings.filledBorderColor = Global.Style.mainColor
        cosmosView.settings.filledColor = Global.Style.mainColor
        cosmosView.settings.fillMode = .half
        cosmosView.settings.minTouchRating = 0
        cosmosView.settings.starSize = Style.StarRatingView.size
        cosmosView.settings.starMargin = Style.StarRatingView.margin
        cosmosView.settings.updateOnTouch = true
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        return cosmosView
    }()

    private let summaryTitleLabel: UILabel = {
        let label = UILabel(textStyle: .title1)
        label.text = Style.SummaryLabel.title
        return label
    }()

    private lazy var summaryBodyLabel: UILabel = {
        let label = UILabel(textStyle: .body)
        label.numberOfLines = 0
        label.text = game.summary
        return label
    }()

    private let reviewTitleLabel: UILabel = {
        let label = UILabel(textStyle: .title1)
        label.text = Style.ReviewLabel.title
        return label
    }()

    private let reviewBodyLabel: UILabel = {
        let label = UILabel(textStyle: .body)
        label.numberOfLines = 0
        label.text = Style.ReviewLabel.placeholder
        return label
    }()

    // MARK: - Initializer

    init(game: Game) {
        self.game = game
        gameDetailView = GameDetailView(game: game)
        super.init(nibName: nil, bundle: nil)
        configureAttributes()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureGameDetailView()
        configureStarRatingView()
        configureGameScrollView()
        configureGameStackView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - Configure

    private func configureAttributes() {
        view.backgroundColor = .systemBackground
    }

    private func configureGameDetailView() {
        gameDetailView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(gameDetailView)
        NSLayoutConstraint.activate([
            gameDetailView.topAnchor.constraint(equalTo: view.topAnchor),
            gameDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureStarRatingView() {
        view.addSubview(starRatingView)
        NSLayoutConstraint.activate([
            starRatingView.topAnchor.constraint(equalTo: gameDetailView.realBottomAnchor,
                                                constant: Style.StarRatingView.verticalInset),
            starRatingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func configureGameScrollView() {
        view.addSubview(gameScrollView)
        NSLayoutConstraint.activate([
            gameScrollView.topAnchor.constraint(equalTo: starRatingView.bottomAnchor,
                                                constant: Style.StarRatingView.verticalInset),
            gameScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            gameScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureGameStackView() {
        gameScrollView.addSubview(gameStackView)
        let heightConstraint = gameStackView.heightAnchor.constraint(
            equalTo: gameScrollView.frameLayoutGuide.heightAnchor)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true

        NSLayoutConstraint.activate([
            gameStackView.topAnchor.constraint(equalTo: gameScrollView.topAnchor),
            gameStackView.leadingAnchor.constraint(equalTo: gameScrollView.leadingAnchor,
                                                   constant: Style.GameStackView.horizontalInset),
            gameStackView.bottomAnchor.constraint(equalTo: gameScrollView.bottomAnchor),
            gameStackView.trailingAnchor.constraint(equalTo: gameScrollView.trailingAnchor,
                                                    constant: -Style.GameStackView.horizontalInset)
        ])

        gameStackView.addArrangedSubview(summaryTitleLabel)
        gameStackView.addArrangedSubview(summaryBodyLabel)
        gameStackView.addArrangedSubview(reviewTitleLabel)
        gameStackView.addArrangedSubview(reviewBodyLabel)
    }
}
