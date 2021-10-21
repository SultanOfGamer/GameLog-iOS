//
//  UpdatedLibrary.swift
//  GameLog
//
//  Created by duckbok on 2021/10/21.
//

struct UpdatedLibrary {

    let id: Int
    let userID: Int
    let gameID: Int
    let userGameRating: Double?
    let userGameMemo: String?
    let userGameStatus: UserGame.Status
    let createdTime: Int
    let updatedTime: Int?
    let wishedTime: Int?

    init(id: Int,
         userID: Int,
         gameID: Int,
         userGameRating: Double? = nil,
         userGameMemo: String? = nil,
         userGameStatus: UserGame.Status,
         createdTime: Int,
         updatedTime: Int? = nil,
         wishedTime: Int? = nil) {
        self.id = id
        self.userID = userID
        self.gameID = gameID
        self.userGameRating = userGameRating
        self.userGameMemo = userGameMemo
        self.userGameStatus = userGameStatus
        self.createdTime = createdTime
        self.updatedTime = updatedTime
        self.wishedTime = wishedTime
    }
}

extension UpdatedLibrary: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        userID = try data.decode(Int.self, forKey: .userID)
        gameID = try data.decode(Int.self, forKey: .gameID)
        userGameRating = try? data.decode(Double.self, forKey: .userGameRating)
        userGameMemo = try? data.decode(String.self, forKey: .userGameMemo)

        let statusName = try data.decode(String.self, forKey: .userGameStatus)
        userGameStatus = UserGame.Status(rawValue: statusName)!

        createdTime = try data.decode(Int.self, forKey: .createdTime)
        updatedTime = try? data.decode(Int.self, forKey: .updatedTime)
        wishedTime = try? data.decode(Int.self, forKey: .wishedTime)
        id = try data.decode(Int.self, forKey: .id)
    }

    private enum CodingKeys: String, CodingKey {
        case data
    }

    private enum DataKeys: String, CodingKey {
        case userID = "userid"
        case gameID = "gameId"
        case userGameRating, userGameMemo, userGameStatus
        case createdTime, updatedTime
        case wishedTime = "wishTime"
        case id
    }
}
