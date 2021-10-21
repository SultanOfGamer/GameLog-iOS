//
//  UserGame.swift
//  GameLog
//
//  Created by duckbok on 2021/10/21.
//

import UIKit

struct UserGame {

    let id: Int
    let userID: Int
    let rating: Double?
    let memo: String?
    let status: Status
    let createdTime: Int
    let updatedTime: Int?
    let wishedTime: Int?

    init(id: Int,
         userID: Int,
         rating: Double? = nil,
         memo: String? = nil,
         status: Status,
         createdTime: Int,
         updatedTime: Int? = nil,
         wishedTime: Int? = nil) {
        self.id = id
        self.userID = userID
        self.rating = rating
        self.memo = memo
        self.status = status
        self.createdTime = createdTime
        self.updatedTime = updatedTime
        self.wishedTime = wishedTime
    }
}

// MARK: - Decodable

extension UserGame: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = try container.decode(Int.self, forKey: .userID)
        rating = try? container.decode(Double.self, forKey: .rating)
        memo = try? container.decode(String.self, forKey: .memo)

        let statusName = try container.decode(String.self, forKey: .status)
        status = Status(rawValue: statusName)!
        createdTime = try container.decode(Int.self, forKey: .createdTime)
        updatedTime = try? container.decode(Int.self, forKey: .updatedTime)
        wishedTime = try? container.decode(Int.self, forKey: .wishedTime)
        id = try container.decode(Int.self, forKey: .id)
    }

    private enum CodingKeys: String, CodingKey {
        case userID = "userid"
        case rating = "userGameRating"
        case memo = "userGameMemo"
        case status = "userGameStatus"
        case createdTime, updatedTime
        case wishedTime = "wishTime"
        case id
    }
}

// MARK: - Status

extension UserGame {

    enum Status: String, Decodable, CaseIterable {
        case wish
        case todo
        case doing
        case done

        var name: String {
            switch self {
            case .wish:
                return "사고 싶어요"
            case .todo:
                return "할 예정이에요"
            case .doing:
                return "하는 중이에요"
            case .done:
                return "다 했어요"
            }
        }

        static func alertController(complection: @escaping (Status) -> Void) -> UIAlertController {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            allCases.forEach { status in
                let action = UIAlertAction(title: status.name, style: .default) { _ in
                    complection(status)
                }
                alertController.addAction(action)
            }
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel))

            return alertController
        }
    }
}
