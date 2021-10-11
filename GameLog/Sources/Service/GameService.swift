//
//  GameService.swift
//  GameLog
//
//  Created by duckbok on 2021/10/11.
//

import Foundation

struct GameService {

    typealias ServiceResult = Result<Game, NetworkRepository.Error>

    private let path: String = "select"
    private let queryKey: String = "gameId"

    private let networkRepository = NetworkRepository()

    func search(by id: Int, completion: @escaping (ServiceResult) -> Void) {
        networkRepository.get(path: path,
                              query: (queryKey, id.description),
                              completion: { (result: ServiceResult) in
            switch result {
            case let .success(game):
                completion(.success(game))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
