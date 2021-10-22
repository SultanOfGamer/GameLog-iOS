//
//  LibrearyService.swift
//  GameLog
//
//  Created by duckbok on 2021/10/13.
//

struct LibraryService {

    typealias LoadResult = Result<Library, NetworkRepository.Error>
    typealias UpdateResult = Result<UserGame, NetworkRepository.Error>

    private let libraryPath: String = "game/library"
    private let wishlistPath: String = "game/wishlist"

    private let networkRepository: NetworkRepository

    init(networkRepository: NetworkRepository = .shared) {
        self.networkRepository = networkRepository
    }

    func load(page: Int,
              sortingMethod: Library.SortingMethod,
              sortingOrder: Library.SortingOrder,
              isWishlist: Bool = false,
              completion: @escaping (LoadResult) -> Void) {
        let path = isWishlist ? wishlistPath : libraryPath
        networkRepository.get(path: path, query: ["page": page.description,
                                                  "sort": sortingMethod.rawValue,
                                                  "sorttype": sortingOrder.rawValue]) { (result: LoadResult) in
            completion(result)
        }
    }

    func store(gameID: Int,
               userGameRating: Double? = nil,
               userGameMemo: String? = nil,
               userGameStatus: UserGame.Status,
               completion: @escaping (UpdateResult) -> Void) {
        var path: String
        var body: [String: String] = ["gameId": gameID.description]

        body.updateValue(userGameStatus.rawValue, forKey: "userGameStatus")
        if userGameStatus == .wish {
            path = wishlistPath
        } else {
            path = libraryPath
            if let userGameRating = userGameRating {
                body.updateValue(userGameRating.description, forKey: "userGameRating")
                body.updateValue(UserGame.Status.done.rawValue, forKey: "userGameStatus")
            }
            if let userGameMemo = userGameMemo {
                body.updateValue(userGameMemo, forKey: "userGameMemo")
                body.updateValue(UserGame.Status.done.rawValue, forKey: "userGameStatus")
            }
        }

        networkRepository.post(path: path,
                               bodyType: .urlencoded(body: body)) { (result: Result<UpdatedLibrary,
                                                                                    NetworkRepository.Error>) in
            switch result {
            case let .success(updated):
                completion(.success(updated.userGame))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func remove(id: Int,
                isWishlist: Bool = false,
                completion: @escaping (Result<String, NetworkRepository.Error>) -> Void) {
        let path = isWishlist ? wishlistPath : libraryPath
        let body: [String: String] = ["id": id.description]

        networkRepository.delete(path: path, bodyType: .urlencoded(body: body)) { result in
            switch result {
            case let .success(responsed):
                completion(.success(responsed.message))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
