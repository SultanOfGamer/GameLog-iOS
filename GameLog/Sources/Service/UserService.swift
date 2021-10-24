//
//  UserService.swift
//  GameLog
//
//  Created by duckbok on 2021/10/12.
//

import Foundation

struct UserService {

    typealias ServiceResult = Result<ResponseMessage, NetworkRepository.Error>

    static let shared = UserService()

    private let loginPath: String = "auth/login"
    private let logoutPath: String = "auth/logout"
    private let signupPath: String = "auth/signup"
    private let validationPath: String = "auth/validation"

    private let profilePath: String = "profile"
    private let preferCategoryPath: String = "profile/category"
    private let profileImagePath: String = "profile/image"
    private let withdrawalPath: String = "profile"

    private let networkRepository: NetworkRepository

    init(networkRepository: NetworkRepository = .shared) {
        self.networkRepository = networkRepository
    }

    func login(email: String, password: String, completion: @escaping (ServiceResult) -> Void) {
        networkRepository.post(path: loginPath,
                               bodyType: .urlencoded(body: ["email": email,
                                                            "password": password])) { (result: ServiceResult) in
            switch result {
            case let .success(responsed):
                completion(.success(responsed))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
