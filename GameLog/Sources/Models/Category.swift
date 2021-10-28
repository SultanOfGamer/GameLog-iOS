//
//  Category.swift
//  GameLog
//
//  Created by duckbok on 2021/10/24.
//

struct Category: Codable, CustomStringConvertible {

    let category: String
    let id: Int
    let name: String

    init?(gameType: GameType) {
        guard let category = gameType.category,
              let id = gameType.id else { return nil }

        self.category = category
        self.id = id
        self.name = gameType.rawValue
    }

    var description: String {
        return GameType(rawValue: name)?.name ?? name
    }
}
