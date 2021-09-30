//
//  Section.swift
//  GameLog
//
//  Created by duckbok on 2021/09/17.
//

import Foundation

struct Section: Hashable {

    var id = UUID()
    let title: String
    var games: [Game]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Section, rhs: Section) -> Bool {
        return (lhs.id == rhs.id)
    }

    static var dummy: Section {
        Section(title: "더미", games: [
        Game.dummy, Game.dummy, Game.dummy, Game.dummy, Game.dummy,
        Game.dummy, Game.dummy, Game.dummy, Game.dummy, Game.dummy
        ])
    }
}
