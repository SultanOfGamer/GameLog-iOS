//
//  GameViewModel.swift
//  GameLog
//
//  Created by duckbok on 2021/10/11.
//

import UIKit

final class GameViewModel {

    private var gameUpdated: ((Game) -> Void)?
    private var userGameUpdated: ((UserGame?) -> Void)?

    private let gameService = GameService()
    private let libraryService = LibraryService()

    private var game: Game? {
        didSet {
            guard let game = game else { return }
            gameUpdated?(game)
        }
    }

    private(set) var userGame: UserGame? {
        didSet {
            userGameUpdated?(userGame)
        }
    }

    func fetchGame(by id: Int) {
        gameService.load(by: id) { [weak self] result in
            switch result {
            case let .success(game):
                self?.game = game
                self?.userGame = game.userGame
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
            case let .success(userGame):
                self?.userGame = userGame
            case let .failure(error):
                print(error)
            }
        }
    }

    func updateUserGame(rating: Double? = nil, memo: String? = nil, status: UserGame.Status) {
        guard let gameID = game?.id,
              let userGameID = userGame?.id else { return }
        libraryService.update(gameID: gameID,
                              userGameID: userGameID,
                              userGameRating: rating,
                              userGameMemo: memo,
                              userGameStatus: status) { [weak self] result in
            switch result {
            case let .success(userGame):
                self?.userGame = userGame
            case let .failure(error):
                print(error)
            }
        }
    }

    func removeUserGame(completion: ((String) -> Void)? = nil) {
        guard let id = userGame?.id else { return }
        let isWishlist = (userGame?.status == .wish)
        libraryService.remove(id: id, isWishlist: isWishlist) { [weak self] result in
            switch result {
            case let .success(message):
                self?.userGame = nil
                completion?(message)
            case let .failure(error):
                completion?(error.localizedDescription)
            }
        }
    }

    func bindGame(by closure: @escaping (Game) -> Void) {
        gameUpdated = closure
    }

    func bindUserGame(by closure: @escaping (UserGame?) -> Void) {
        userGameUpdated = closure
    }
}
