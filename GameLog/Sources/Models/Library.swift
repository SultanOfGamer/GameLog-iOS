//
//  Library.swift
//  GameLog
//
//  Created by duckbok on 2021/10/13.
//

import UIKit

struct Library: Hashable {

    let id = UUID()
    let data: [Library.Game]

    init(data: [Library.Game]) {
        self.data = data
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Library, rhs: Library) -> Bool {
        return (lhs.id == rhs.id)
    }
}

extension Library: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([Library.Game].self, forKey: .data)
    }

    private enum CodingKeys: String, CodingKey {
        case data
    }
}

// MARK: - Library.Game

extension Library {

    struct Game: Decodable, Hashable {
        let gameID: Int
        let name: String
        let cover: Cover
        let userGameStatus: UserGameStatus?
        let id: Int

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            gameID = try container.decode(Int.self, forKey: .gameID)
            name = try container.decode(String.self, forKey: .name)
            cover = try container.decode(Cover.self, forKey: .cover)

            let status = try container.decode(String.self, forKey: .userGameStatus)
            self.userGameStatus = UserGameStatus(rawValue: status)

            id = try container.decode(Int.self, forKey: .id)
        }

        private enum CodingKeys: String, CodingKey {
            case gameID = "gameId"
            case name = "gameName"
            case cover, userGameStatus, id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Library.Game, rhs: Library.Game) -> Bool {
            return (lhs.id == rhs.id)
        }
    }
}

// MARK: - Library.Sorting

extension Library {

    enum SortingMethod: String, CaseIterable {
        case aggregatedRating = "aggregated_rating"
        case firstReleaseDate = "first_release_date"
        case gameName, createdTime

        var name: String {
            switch self {
            case .aggregatedRating:
                return "기관 별점 순"
            case .firstReleaseDate:
                return "출시일 순"
            case .gameName:
                return "게임이름 순"
            case .createdTime:
                return "담은 순"
            }
        }

        static func alertController(complection: @escaping (SortingMethod) -> Void) -> UIAlertController {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            allCases.forEach { sortingMethod in
                let action = UIAlertAction(title: sortingMethod.name, style: .default) { _ in
                    complection(sortingMethod)
                }
                alertController.addAction(action)
            }
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel))

            return alertController
        }
    }

    enum SortingOrder: String, CaseIterable {
        case ascending = "asc"
        case descending = "desc"

        var toggle: SortingOrder {
            switch self {
            case .ascending:
                return .descending
            case .descending:
                return .ascending
            }
        }

        var sign: UIImage {
            switch self {
            case .ascending:
                return UIImage(systemName: "arrowtriangle.up.circle.fill")!
            case .descending:
                return UIImage(systemName: "arrowtriangle.down.circle.fill")!
            }
        }
    }
}
