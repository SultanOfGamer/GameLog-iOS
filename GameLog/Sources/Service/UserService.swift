//
//  UserService.swift
//  GameLog
//
//  Created by duckbok on 2021/10/12.
//

import Foundation

struct UserService {

    typealias ServiceResult = Result<String?, NetworkRepository.Error>

    static let shared = UserService()

    private let loginPath: String = "auth/login"

    private let networkRepository: NetworkRepository

    init(networkRepository: NetworkRepository = .shared) {
        self.networkRepository = networkRepository
    }

    func login(email: String, password: String, completion: @escaping (ServiceResult) -> Void) {
        networkRepository.post(path: loginPath, bodies: ["email": email, "password": password]) { result in
            switch result {
            case let .success((message, cookies)):
                cookies?.forEach { UserDefaults.standard.set( $0.value, forKey: $0.name) }
                completion(.success(message))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
