//
//  UpdatedLibrary.swift
//  GameLog
//
//  Created by duckbok on 2021/10/21.
//

struct UpdatedLibrary: Decodable {

    let userGame: UserGame

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userGame = try container.decode(UserGame.self, forKey: .data)
    }

    private enum CodingKeys: String, CodingKey {
        case data
    }
}
