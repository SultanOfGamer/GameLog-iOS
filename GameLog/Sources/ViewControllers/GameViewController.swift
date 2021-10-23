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
        enum BarButton {
            static let plusImage = UIImage(systemName: "plus.circle.fill")!
            static let minusImage = UIImage(systemName: "minus.circle.fill")!
        }

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
        }
    }

    private let gameViewModel = GameViewModel()

    // MARK: - View

    private let gameDetailView = GameDetailView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large, color: Global.Style.mainColor)
    private lazy var statusButtonItem = UIBarButtonItem(image: nil,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(touchedUserStatus))

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
        cosmosView.isHidden = true
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

    private lazy var reviewTitleButton: UIButton = {
        let button = UIButton()
        button.setTitle(Style.ReviewLabel.title, for: .normal)
        button.setTitleColor(Global.Style.mainColor, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.addTarget(self, action: #selector(touchedReviewButton), for: .touchUpInside)
        return button
    }()

    private let reviewBodyLabel: UILabel = {
        let label = UILabel(textStyle: .body)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Initializer

    init(gameID: Int, name: String? = nil, cover: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)
        configureAttributes()

        gameViewModel.bindGame(by: bindingGame)
        gameViewModel.bindUserGame(by: bindingUserGame)
        starRatingView.didFinishTouchingCosmos = touchedStarRatingView(_:)

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

        view.addSubview(loadingIndicator)
        loadingIndicator.startLoading(to: gameScrollView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .label
    }

    // MARK: - Configure

    private func configureAttributes() {
        view.backgroundColor = .systemBackground
        navigationItem.setRightBarButton(statusButtonItem, animated: true)
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
        gameStackView.addArrangedSubview(reviewTitleButton)
        gameStackView.addArrangedSubview(reviewBodyLabel)
    }
}

// MARK: - Binding

extension GameViewController {

    private func bindingGame(_ game: Game) {
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
            guard let self = self else { return }

            self.loadingIndicator.stopLoading(to: self.gameScrollView)
            self.summaryBodyLabel.text = game.summary
            self.gameDetailView.titleLabel.text = game.name
            self.gameDetailView.releaseDateLabel.text = game.releaseDate.string
            self.gameDetailView.aggregatedLabel.text = "★\(game.aggregated.rating) (\(game.aggregated.count))"
        }
    }

    private func bindingUserGame(_ userGame: UserGame?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let rating = userGame?.rating ?? 0
            self.starRatingView.isHidden = false
            self.starRatingView.rating = rating
            self.reviewBodyLabel.text = userGame?.memo

            if rating > 0 {
                self.reviewTitleButton.isHidden = false
                self.reviewBodyLabel.isHidden = false
            } else {
                self.reviewTitleButton.isHidden = true
                self.reviewBodyLabel.isHidden = true
            }

            if userGame == nil {
                self.statusButtonItem.image = Style.BarButton.plusImage
                self.statusButtonItem.tintColor = .systemGreen
            } else {
                self.statusButtonItem.image = Style.BarButton.minusImage
                self.statusButtonItem.tintColor = .systemRed
            }
        }
    }
}

// MARK: - Action

extension GameViewController {

    private func touchedStarRatingView(_ rating: Double) {
        if let userGame = gameViewModel.userGame {
            if rating > 0 {
                gameViewModel.updateUserGame(rating: rating, status: .done)
            } else if userGame.status != .wish {
                gameViewModel.removeUserGame()
            }
        } else if rating > 0 {
            gameViewModel.addUserGame(rating: rating, status: .done)
        }
    }

    @objc private func touchedUserStatus() {
        statusButtonItem.isEnabled = false

        if gameViewModel.userGame?.status != nil {
            gameViewModel.removeUserGame { [weak self] message in
                DispatchQueue.main.async {
                    self?.statusButtonItem.isEnabled = true
                }
                print(message)
            }
        } else {
            let alertController = UserGame.Status.alertController { [weak self] userStatus in
                self?.gameViewModel.addUserGame(status: userStatus)
            }
            present(alertController, animated: true)
            statusButtonItem.isEnabled = true
        }
    }

    @objc private func touchedReviewButton() {
        let reviewViewController = ReviewViewController(gameViewModel: gameViewModel)
        let containerViewController = UINavigationController(rootViewController: reviewViewController)
        present(containerViewController, animated: true)
    }
}
