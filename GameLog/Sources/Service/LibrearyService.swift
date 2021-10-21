//
//  LibrearyService.swift
//  GameLog
//
//  Created by duckbok on 2021/10/13.
//

struct LibraryService {

    typealias LoadResult = Result<Library, NetworkRepository.Error>
    typealias UpdateResult = Result<UpdatedLibrary, NetworkRepository.Error>

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

        if userGameStatus == .wish {
            path = wishlistPath
            body.updateValue(userGameStatus.rawValue, forKey: "userGameStatus")
        } else {
            path = libraryPath
            if let userGameRating = userGameRating {
                body.updateValue(userGameRating.description, forKey: "userGameRating")
            }
            if let userGameMemo = userGameMemo {
                body.updateValue(userGameMemo, forKey: "userGameMemo")
            }
            body.updateValue(userGameStatus.rawValue, forKey: "userGameStatus")
        }

        networkRepository.post(path: path, bodies: body) { (result: UpdateResult) in
            completion(result)
        }
    }
}
