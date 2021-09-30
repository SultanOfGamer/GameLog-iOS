//
//  Game.swift
//  GameLog
//
//  Created by duckbok on 2021/09/16.
//

import Foundation

struct Game: Hashable {

    let id = UUID()
    let name: String
    let aggregated: (rating: Double, count: Int)
    let involvedCompanyNames: [String]
    let releaseDate: Date
    let gameModes: [String]
    let genres: [String]
    let platforms: [String]
    let themes: [String]
    let summary: String
    let cover: String
    let screenshot: String

    static var dummy: Game {
        return Game(name: "Capstone Design",
                    aggregated: (4.5, 2),
                    involvedCompanyNames: [],
                    releaseDate: Date(),
                    gameModes: ["Single player"],
                    genres: ["Fighting"],
                    platforms: ["PlayStation 4"],
                    themes: ["Action"],
                    summary: "Capstone Design is a good lecture.",
                    cover: "cover",
                    screenshot: "screenshot")
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Game, rhs: Game) -> Bool {
        return (lhs.id == rhs.id)
    }
}
