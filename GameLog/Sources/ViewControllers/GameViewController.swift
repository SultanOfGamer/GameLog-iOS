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
            static let size: Double = 40
            static let margin: Double = 5
            static let emptyColor: UIColor = .systemGray3
        }
        enum GameStackView {
            static let spacing: CGFloat = 10
        }
    }

    private var game: Game

    private let gameScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let gameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Style.GameStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let starRatingView: CosmosView = {
        let cosmosView = CosmosView()
        cosmosView.settings.emptyBorderColor = Style.StarRatingView.emptyColor
        cosmosView.settings.emptyColor = Style.StarRatingView.emptyColor
        cosmosView.settings.filledBorderColor = GameLog.Style.mainColor
        cosmosView.settings.filledColor = GameLog.Style.mainColor
        cosmosView.settings.fillMode = .half
        cosmosView.settings.minTouchRating = 0
        cosmosView.settings.starSize = Style.StarRatingView.size
        cosmosView.settings.starMargin = Style.StarRatingView.margin
        cosmosView.settings.updateOnTouch = true
        cosmosView.rating = 0
        return cosmosView
    }()

    // MARK: - Initializer

    init(game: Game) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
        configureAttributes()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        configureGameScrollView()
        configureGameStackView()
        configureStarRatingView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }

    // MARK: - Configure

    private func configureAttributes() {
        title = game.name
        view.backgroundColor = .systemBackground
    }

    private func configureGameScrollView() {
        view.addSubview(gameScrollView)
        NSLayoutConstraint.activate([
            gameScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gameScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gameScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
            gameStackView.widthAnchor.constraint(equalTo: gameScrollView.widthAnchor)
        ])
    }

    private func configureStarRatingView() {
        gameStackView.addArrangedSubview(starRatingView)
    }
}
