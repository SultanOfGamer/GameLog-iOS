//
//  Search.swift
//  GameLog
//
//  Created by duckbok on 2021/10/18.
//

import Foundation

struct Search: Hashable {

    let id = UUID()
    let games: [Section.Game]

    init(games: [Section.Game] = []) {
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
        let data = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        var decodedGames: [Section.Game]
        decodedGames = try data.decode([Section.Game].self, forKey: .gameName)
        if decodedGames.isEmpty {
            decodedGames = try data.decode([Section.Game].self, forKey: .alterName)
        }
        games = decodedGames
    }

    private enum CodingKeys: String, CodingKey {
        case data
    }

    private enum DataKeys: String, CodingKey {
        case gameName, alterName
    }
}
