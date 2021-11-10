//
//  UserService.swift
//  GameLog
//
//  Created by duckbok on 2021/10/12.
//

import UIKit

struct UserService {

    typealias MessageResult = Result<ResponseMessage, NetworkRepository.Error>
    typealias ProfileResult = Result<Profile, NetworkRepository.Error>

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

    func profile(completion: @escaping (ProfileResult) -> Void) {
        networkRepository.get(path: profilePath, completion: completion)
    }

    func profileImage(path: String, completion: @escaping (UIImage) -> Void) {
        let url = networkRepository.baseURL + path
        NetworkRepository.fetchImage(from: url, completion: completion)
    }

    func login(email: String, password: String, completion: @escaping (MessageResult) -> Void) {
        networkRepository.post(path: loginPath,
                               bodyType: .urlencoded(body: ["email": email,
                                                            "password": password])) { (result: MessageResult) in
            switch result {
            case let .success(responsed):
                completion(.success(responsed))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    static func testLogin(completion: @escaping () -> Void) {
        guard UserDefaults.standard.value(forKey: "connect.sid") != nil else {
            completion()
            return
        }

        UserService.shared.login(email: "test@gmail.com", password: "123456") { _ in
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
