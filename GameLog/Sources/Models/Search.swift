//
//  Search.swift
//  GameLog
//
//  Created by duckbok on 2021/10/18.
//

import Foundation

struct Search: Hashable {

    let id = UUID()
    let games: [Search.Game]

    init(games: [Search.Game] = []) {
        self.games = games
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Search, rhs: Search) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Decodable

extension Search: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var decodedGames: [Search.Game]
        decodedGames = try container.decode([Search.Game].self, forKey: .gameName)
        if decodedGames.isEmpty {
            decodedGames = try container.decode([Search.Game].self, forKey: .alterName)
        }
        games = decodedGames
    }

    private enum CodingKeys: String, CodingKey {
        case gameName, alterName
    }
}

// MARK: - Search.Game

extension Search {

    struct Game: Decodable, Hashable {
        let id: Int
        let name: String
        let cover: Cover

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            cover = try container.decode([Cover].self, forKey: .cover)[0]
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Search.Game, rhs: Search.Game) -> Bool {
            return lhs.id == rhs.id
        }

        private enum CodingKeys: String, CodingKey {
            case id, name, cover
        }
    }
}
