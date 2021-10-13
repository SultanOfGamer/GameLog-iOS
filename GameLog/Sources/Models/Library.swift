//
//  Library.swift
//  GameLog
//
//  Created by duckbok on 2021/10/13.
//

import Foundation

struct Library {

    let data: [Library.Game]

    init(data: [Library.Game]) {
        self.data = data
    }
}

extension Library: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([Library.Game].self, forKey: .data)
    }

    private enum CodingKeys: String, CodingKey {
        case data
    }
}

// MARK: - Library.Game

extension Library {

    struct Game: Decodable {
        let gameID: Int
        let name: String
        let cover: Cover
        let userGameStatus: UserGameStatus?
        let id: Int

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            gameID = try container.decode(Int.self, forKey: .gameID)
            name = try container.decode(String.self, forKey: .name)
            cover = try container.decode(Cover.self, forKey: .cover)

            let status = try container.decode(String.self, forKey: .userGameStatus)
            self.userGameStatus = UserGameStatus(rawValue: status)

            id = try container.decode(Int.self, forKey: .id)
        }

        private enum CodingKeys: String, CodingKey {
            case gameID = "gameId"
            case name = "gameName"
            case cover, userGameStatus, id
        }
    }
}
