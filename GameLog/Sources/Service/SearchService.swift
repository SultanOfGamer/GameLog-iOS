//
//  SearchService.swift
//  GameLog
//
//  Created by duckbok on 2021/10/18.
//

struct SearchService {

    typealias ServiceResult = Result<Search, NetworkRepository.Error>

    private let path: String = "search"
    private let queryKey: String = "name"

    private let networkRepository: NetworkRepository

    init(networkRepository: NetworkRepository = .shared) {
        self.networkRepository = networkRepository
    }

    func search(by name: String, completion: @escaping (ServiceResult) -> Void) {
        networkRepository.get(path: path, query: [queryKey: name]) { (result: ServiceResult) in
            completion(result)
        }
    }
}
