//
//  GameViewModel.swift
//  GameLog
//
//  Created by duckbok on 2021/10/11.
//

import UIKit

final class GameViewModel {

    private var fetched: ((Game) -> Void)?

    private let gameService = GameService()

    private var game: Game? {
        didSet {
            guard let game = game else { return }
            fetched?(game)
        }
    }

    func fetchGame(by id: Int) {
        gameService.search(by: id) { [weak self] result in
            switch result {
            case let .success(game):
                self?.game = game
            case let .failure(error):
                print(error)
            }
        }
    }

    func bind(closure: @escaping (Game) -> Void) {
        fetched = closure
    }
}
