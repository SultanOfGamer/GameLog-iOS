//
//  SettingContent.swift
//  GameLog
//
//  Created by duckbok on 2021/11/07.
//

import UIKit

enum SettingContent: Int, CaseIterable {

    typealias Section = (numberOfRows: Int, rows: [Row])
    typealias Row = (accessoryType: UITableViewCell.AccessoryType,
                     text: String, secondaryText: String?, image: UIImage?)

    case profile
    case modify
    case logout
    case opensource
    case delete

    var numberOfRows: Int {
        switch self {
        case .profile: return 1
        case .modify: return 2
        case .logout: return 1
        case .opensource: return 1
        case .delete: return 1
        }
    }

    var texts: [String] {
        switch self {
        case .profile: return []
        case .modify: return ["프로필사진 변경", "선호장르 변경"]
        case .logout: return ["로그아웃"]
        case .opensource: return ["오픈소스 라이선스"]
        case .delete: return ["계정 삭제하기"]
        }
    }

    static func contents(nickname: String, email: String, image: UIImage? = nil) -> [SettingContent.Section] {
        var sections: [SettingContent.Section] = []

        allCases.forEach { content in
            switch content {
            case .profile:
                sections.append((content.numberOfRows, [(.none, nickname, email, image)]))
            case .modify:
                sections.append((content.numberOfRows, content.texts.map {(.disclosureIndicator, $0, nil, nil)}))
            default:
                sections.append((content.numberOfRows, content.texts.map {(.none, $0, nil, nil)}))
            }
        }

        return sections
    }
}
