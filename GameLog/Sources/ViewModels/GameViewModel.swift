//
//  GameViewModel.swift
//  GameLog
//
//  Created by duckbok on 2021/10/11.
//

import UIKit

final class GameViewModel {

    private var gameUpdated: ((Game) -> Void)?
    private var ratingUpdated: ((Double?) -> Void)?
    private var memoUpdated: ((String?) -> Void)?
    private var statusUpdated: ((UserGame.Status?) -> Void)?

    private let gameService = GameService()
    private let libraryService = LibraryService()

    private var game: Game? {
        didSet {
            guard let game = game else { return }
            gameUpdated?(game)
        }
    }

    private(set) var userGameRating: Double? {
        didSet {
            ratingUpdated?(userGameRating)
        }
    }

    private(set) var userGameMemo: String? {
        didSet {
            memoUpdated?(userGameMemo)
        }
    }

    private(set) var userGameStatus: UserGame.Status? {
        didSet {
            statusUpdated?(userGameStatus)
        }
    }

    func fetchGame(by id: Int) {
        gameService.load(by: id) { [weak self] result in
            switch result {
            case let .success(game):
                self?.game = game
                self?.userGameRating = game.userGame?.rating
                self?.userGameMemo = game.userGame?.memo
                self?.userGameStatus = game.userGame?.status
            case let .failure(error):
                print(error)
            }
        }
    }

    func addUserGame(rating: Double? = nil, memo: String? = nil, status: UserGame.Status) {
        guard let gameID = game?.id else { return }
        libraryService.store(gameID: gameID,
                             userGameRating: rating,
                             userGameMemo: memo,
                             userGameStatus: status) { [weak self] result in
            switch result {
            case let .success(library):
                self?.userGameStatus = library.userGameStatus
            case let .failure(error):
                print(error)
            }
        }
    }

    func bindGame(closure: @escaping (Game) -> Void) {
        gameUpdated = closure
    }

    func bindRating(closure: @escaping (Double?) -> Void) {
        ratingUpdated = closure
    }

    func bindMemo(closure: @escaping (String?) -> Void) {
        memoUpdated = closure
    }

    func bindStatus(closure: @escaping (UserGame.Status?) -> Void) {
        statusUpdated = closure
    }
}
