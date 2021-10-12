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

    private let gameViewModel = GameViewModel()

    // MARK: - View

    private let gameDetailView = GameDetailView()

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
        stackView.layoutMargins = UIEdgeInsets(top: 0,
                                               left: Style.GameStackView.horizontalInset,
                                               bottom: 20,
                                               right: Style.GameStackView.horizontalInset)
        stackView.isLayoutMarginsRelativeArrangement = true
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

    private let summaryBodyLabel: UILabel = {
        let label = UILabel(textStyle: .body)
        label.numberOfLines = 0
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

    init(gameID: Int, name: String? = nil, cover: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)
        configureAttributes()
        gameViewModel.bind { [weak self] game in
            self?.bindingClosure(game)
        }
        gameViewModel.fetchGame(by: gameID)
        gameDetailView.setBasicData(name: name, cover: cover)
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
            starRatingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starRatingView.heightAnchor.constraint(equalToConstant: Style.StarRatingView.size)
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
            gameStackView.leadingAnchor.constraint(equalTo: gameScrollView.leadingAnchor),
            gameStackView.bottomAnchor.constraint(equalTo: gameScrollView.bottomAnchor),
            gameStackView.trailingAnchor.constraint(equalTo: gameScrollView.trailingAnchor),
            gameStackView.widthAnchor.constraint(lessThanOrEqualTo: gameScrollView.widthAnchor)
        ])

        gameStackView.addArrangedSubview(summaryTitleLabel)
        gameStackView.addArrangedSubview(summaryBodyLabel)
        gameStackView.addArrangedSubview(reviewTitleLabel)
        gameStackView.addArrangedSubview(reviewBodyLabel)
    }

    private func bindingClosure(_ game: Game) {
        NetworkRepository.fetchImage(from: game.screenshot, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.gameDetailView.screenshotImageView.image = image
            }
        })

        NetworkRepository.fetchImage(from: game.cover, completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.gameDetailView.coverImageView.image = image
            }
        })

        DispatchQueue.main.async { [weak self] in
            self?.summaryBodyLabel.text = game.summary
            self?.gameDetailView.titleLabel.text = game.name
            self?.gameDetailView.releaseDateLabel.text = game.releaseDate.string
            self?.gameDetailView.aggregatedLabel.text = "★ \(game.aggregated.rating) (\(game.aggregated.count))"
        }
    }
}
