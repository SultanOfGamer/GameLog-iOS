//
//  Profile.swift
//  GameLog
//
//  Created by duckbok on 2021/10/24.
//

struct Profile {

    let id: Int
    let email: String
    let nickname: String
    let profileImagePath: String?
    let preferCategories: [Category]
}

// MARK: - Decodable

extension Profile: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        email = try data.decode(String.self, forKey: .email)
        nickname = try data.decode(String.self, forKey: .nickname)

        let profileImage = try? data.nestedContainer(keyedBy: ProfileImageKeys.self, forKey: .profileImagePath)
        profileImagePath = try profileImage?.decode(String.self, forKey: .url)

        preferCategories = try data.decode([Category].self, forKey: .preferCategories)
        id = try data.decode(Int.self, forKey: .id)
    }

    private enum CodingKeys: String, CodingKey {
        case data
    }

    private enum DataKeys: String, CodingKey {
        case email, nickname
        case profileImagePath = "profileImage"
        case preferCategories = "preferCategory"
        case id
    }

    private enum ProfileImageKeys: String, CodingKey {
        case url
    }
}
