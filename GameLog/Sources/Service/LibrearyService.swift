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

    func load(page: Int, sortMethod: SortMethod, sortOrder: SortOrder, completion: @escaping (ServiceResult) -> Void) {
        networkRepository.get(path: getPath, query: ["page": page.description,
                                                     "sort": sortMethod.rawValue,
                                                     "sorttype": sortOrder.rawValue]) { (result: ServiceResult) in
            completion(result)
        }
    }
}

// MARK: - SortMethod

extension LibraryService {

    enum SortMethod: String {
        case aggregatedRating = "aggregated_rating"
        case firstReleaseDate = "first_release_date"
        case gameName, createdTime

        var name: String {
            switch self {
            case .aggregatedRating:
                return "기관 별점 순"
            case .firstReleaseDate:
                return "출시일 순"
            case .gameName:
                return "게임이름순"
            case .createdTime:
                return "담은 순"
            }
        }
    }

    enum SortOrder: String {
        case ascending = "asc"
        case descending = "desc"
    }
}
