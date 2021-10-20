//
//  LibrearyService.swift
//  GameLog
//
//  Created by duckbok on 2021/10/13.
//

struct LibraryService {

    typealias ServiceResult = Result<Library, NetworkRepository.Error>

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
              completion: @escaping (ServiceResult) -> Void) {
        let path = isWishlist ? wishlistPath : libraryPath
        networkRepository.get(path: path, query: ["page": page.description,
                                                  "sort": sortingMethod.rawValue,
                                                  "sorttype": sortingOrder.rawValue]) { (result: ServiceResult) in
            completion(result)
        }
    }
}
