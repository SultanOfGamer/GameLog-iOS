//
//  Category.swift
//  GameLog
//
//  Created by duckbok on 2021/10/24.
//

struct Category: Codable {

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

    var gameType: GameType? {
        return .init(rawValue: name)
    }
}
