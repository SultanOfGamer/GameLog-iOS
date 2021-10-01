//
//  GameViewController.swift
//  GameLog
//
//  Created by duckbok on 2021/10/01.
//

import UIKit

final class GameViewController: UIViewController {

    private var game: Game

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
}
