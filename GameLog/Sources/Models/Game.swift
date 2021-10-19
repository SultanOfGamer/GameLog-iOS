//
//  Game.swift
//  GameLog
//
//  Created by duckbok on 2021/09/16.
//

import UIKit

struct Game {

    let id: Int
    let name: String
    let aggregated: (rating: Double, count: Int)
    let involvedCompanies: [String]
    let releaseDate: Date
    let gameModes: [String]
    let genres: [String]
    let platforms: [String]
    let themes: [String]
    let storyline: String?
    let summary: String
    let cover: String
    let screenshot: String
    let userGame: UserGame?

    init(id: Int,
         name: String,
         aggregated: (rating: Double, count: Int),
         involvedCompanies: [String],
         releaseDate: Date,
         gameModes: [String],
         genres: [String],
         platforms: [String],
         themes: [String],
         storyline: String? = nil,
         summary: String,
         cover: String,
         screenshot: String,
         userGame: UserGame? = nil) {
        self.id = id
        self.name = name
        self.aggregated = aggregated
        self.involvedCompanies = involvedCompanies
        self.releaseDate = releaseDate
        self.gameModes = gameModes
        self.genres = genres
        self.platforms = platforms
        self.themes = themes
        self.storyline = storyline
        self.summary = summary
        self.cover = cover
        self.screenshot = screenshot
        self.userGame = userGame
    }

    static var dummy: Game? {
        let dummyAsset = NSDataAsset(name: "DummyGame")!
        return try? JSONDecoder().decode(Game.self, from: dummyAsset.data)
    }
}

// MARK: - Decodable

extension Game: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userGame = try container.decode(UserGame?.self, forKey: .userGame)

        let gameDetail = try container.nestedContainer(keyedBy: GameDetailKeys.self, forKey: .gameDetail)
        id = try gameDetail.decode(Int.self, forKey: .id)
        name = try gameDetail.decode(String.self, forKey: .name)
        aggregated = (try gameDetail.decode(Double.self, forKey: .aggregatedRating),
                      try gameDetail.decode(Int.self, forKey: .aggregatedCount))

        let companies = try gameDetail.decode([InvolvedCompany].self, forKey: .involvedCompanies)
        involvedCompanies = companies.map { $0.company.name }

        releaseDate = Date(timeIntervalSince1970: try gameDetail.decode(TimeInterval.self, forKey: .releaseDate))
        gameModes = try gameDetail.decode([GameMode].self, forKey: .gameModes).map { $0.name }
        genres = try gameDetail.decode([Genre].self, forKey: .genres).map { $0.name }
        platforms = try gameDetail.decode([Platform].self, forKey: .platforms).map { $0.name }
        themes = try gameDetail.decode([Theme].self, forKey: .themes).map { $0.name }
        storyline = try? gameDetail.decode(String.self, forKey: .storyline)
        summary = try gameDetail.decode(String.self, forKey: .summary)
        cover = try gameDetail.decode([Cover].self, forKey: .cover)[0].url
        screenshot = try gameDetail.decode([Screenshot].self, forKey: .screenshots).randomElement()!.url
    }

    private enum CodingKeys: String, CodingKey {
        case userGame, gameDetail
    }

    private enum GameDetailKeys: String, CodingKey {
        case id, name
        case aggregatedRating = "aggregated_rating"
        case aggregatedCount = "aggregated_rating_count"
        case involvedCompanies = "involved_companies"
        case releaseDate = "first_release_date"
        case gameModes = "game_modes"
        case genres, platforms, themes, storyline, summary, cover, screenshots
    }
}

// MARK: - UserGame

struct UserGame: Decodable {

    let id: Int
    let userID: Int
    let rating: Double?
    let memo: String?
    let status: Status
    let modifiedTime: Int
    let wishedTime: Int?

    init(id: Int,
         userID: Int,
         rating: Double? = nil,
         memo: String? = nil,
         status: Status,
         modifiedTime: Int,
         wishedTime: Int? = nil) {
        self.id = id
        self.userID = userID
        self.rating = rating
        self.memo = memo
        self.status = status
        self.modifiedTime = modifiedTime
        self.wishedTime = wishedTime
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = try container.decode(Int.self, forKey: .userID)
        rating = try? container.decode(Double.self, forKey: .rating)
        memo = try? container.decode(String.self, forKey: .memo)

        let statusName = try container.decode(String.self, forKey: .status)
        status = Status(rawValue: statusName)!
        modifiedTime = try container.decode(Int.self, forKey: .modifiedTime)
        wishedTime = try? container.decode(Int.self, forKey: .wishedTime)
        id = try container.decode(Int.self, forKey: .id)
    }

    private enum CodingKeys: String, CodingKey {
        case userID = "userid"
        case rating = "userGameRating"
        case memo = "userGameMemo"
        case status = "userGameStatus"
        case modifiedTime = "createdTime"
        case wishedTime = "wishTime"
        case id
    }

    enum Status: String, Decodable {
        case wish
        case todo
        case doing
        case done
    }
}

// MARK: - GameDetail

struct InvolvedCompany: Decodable {

    let id: Int
    let company: Company

    init(id: Int, company: Company) {
        self.id = id
        self.company = company
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        company = try container.decode([Company].self, forKey: .company)[0]
    }

    private enum CodingKeys: String, CodingKey {
        case id, company
    }
}

struct Company: Decodable {

    let id: Int
    let name: String
}

struct GameMode: Decodable {

    let id: Int
    let name: String
}

struct Genre: Decodable {

    let id: Int
    let name: String
}

struct Platform: Decodable {

    let id: Int
    let category: Int?
    let name: String
    let categoryName: String?

    private enum CodingKeys: String, CodingKey {
        case id, category, name
        case categoryName = "category_name"
    }
}

struct Theme: Decodable {

    let id: Int
    let name: String
}

struct Cover: Decodable {

    let id: Int
    let gameID: Int
    let url: String

    private let erasingURL: String = "//images.igdb.com/igdb/image/upload/t_thumb/"
    private let baseURL: String = "https://images.igdb.com/igdb/image/upload/t_cover_big/"

    init(id: Int, gameID: Int, url: String) {
        self.id = id
        self.gameID = gameID
        self.url = url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        gameID = try container.decode(Int.self, forKey: .gameID)
        url = try baseURL + container.decode(String.self, forKey: .url).replacingOccurrences(of: erasingURL, with: "")
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case gameID = "game"
        case url
    }
}

struct Screenshot: Decodable {

    let id: Int
    let gameID: Int
    let url: String

    private let erasingURL: String = "//images.igdb.com/igdb/image/upload/t_thumb/"
    private let baseURL: String = "https://images.igdb.com/igdb/image/upload/t_original/"

    init(id: Int, gameID: Int, url: String) {
        self.id = id
        self.gameID = gameID
        self.url = url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        gameID = try container.decode(Int.self, forKey: .gameID)
        url = try baseURL + container.decode(String.self, forKey: .url).replacingOccurrences(of: erasingURL, with: "")
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case gameID = "game"
        case url
    }
}
