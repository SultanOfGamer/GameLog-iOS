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
        email = try container.decode(String.self, forKey: .email)
        nickname = try container.decode(String.self, forKey: .nickname)

        let profileImage = try? container.nestedContainer(keyedBy: ProfileImageKeys.self, forKey: .profileImagePath)
        profileImagePath = try profileImage?.decode(String.self, forKey: .url)

        preferCategories = try container.decode([Category].self, forKey: .preferCategories)
        id = try container.decode(Int.self, forKey: .id)
    }

    private enum CodingKeys: String, CodingKey {
        case email, nickname
        case profileImagePath = "profileImage"
        case preferCategories = "preferCategory"
        case id
    }

    private enum ProfileImageKeys: String, CodingKey {
        case url
    }
}
