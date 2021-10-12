//
//  HomeService.swift
//  GameLog
//
//  Created by duckbok on 2021/10/11.
//

import Foundation

struct HomeService {

    typealias ServiceResult = Result<[Section], NetworkRepository.Error>

    private let networkRepository: NetworkRepository

    init(networkRepository: NetworkRepository = .shared) {
        self.networkRepository = networkRepository
    }

    func load(completion: @escaping (ServiceResult) -> Void) {
        networkRepository.get { (result: ServiceResult) in
            switch result {
            case let .success(section):
                completion(.success(section))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
