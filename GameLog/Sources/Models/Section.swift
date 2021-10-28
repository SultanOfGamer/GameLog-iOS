//
//  Section.swift
//  GameLog
//
//  Created by duckbok on 2021/09/17.
//

import UIKit

struct Section: Hashable {

    let id = UUID()
    let type: String
    let games: [Section.Game]

    init(type: String, games: [Section.Game]) {
        self.type = type
        self.games = games
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Section, rhs: Section) -> Bool {
        return (lhs.id == rhs.id)
    }
}

// MARK: - Decodable

extension Section: Decodable {

    static var dummies: [Section]? {
        let dummyAsset = NSDataAsset(name: "DummyHome")!
        return try? JSONDecoder().decode([Section].self, from: dummyAsset.data)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeName = try container.decode(String.self, forKey: .type)

        if let gameType = GameType(rawValue: typeName) {
            type = gameType.name
        } else {
            type = typeName
        }

        games = try container.decode([Section.Game].self, forKey: .games)
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case games = "game"
    }
}

// MARK: - Section.Game

extension Section {

    struct Game: Hashable, Decodable {

        let uuid = UUID()
        let id: Int
        let name: String
        let cover: Cover

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            cover = try container.decode([Cover].self, forKey: .cover)[0]
        }

        private enum CodingKeys: String, CodingKey {
            case id, name, cover
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(uuid)
        }

        static func == (lhs: Section.Game, rhs: Section.Game) -> Bool {
            return (lhs.uuid == rhs.uuid)
        }
    }
}
