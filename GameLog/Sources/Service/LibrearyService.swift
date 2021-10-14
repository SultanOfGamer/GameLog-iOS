//
//  LibrearyService.swift
//  GameLog
//
//  Created by duckbok on 2021/10/13.
//

struct LibraryService {

    typealias ServiceResult = Result<Library, NetworkRepository.Error>

    private let getPath: String = "game/library/get/"

    private let networkRepository: NetworkRepository

    init(networkRepository: NetworkRepository = .shared) {
        self.networkRepository = networkRepository
    }

    func load(page: Int,
              sortingMethod: Library.SortingMethod,
              sortingOrder: Library.SortingOrder,
              completion: @escaping (ServiceResult) -> Void) {
        networkRepository.get(path: getPath, query: ["page": page.description,
                                                     "sort": sortingMethod.rawValue,
                                                     "sorttype": sortingOrder.rawValue]) { (result: ServiceResult) in
            completion(result)
        }
    }
}
