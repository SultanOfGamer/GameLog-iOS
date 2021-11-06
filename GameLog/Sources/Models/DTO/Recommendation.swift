//
//  Recommendation.swift
//  GameLog
//
//  Created by duckbok on 2021/11/06.
//

struct Recommendation: Decodable {

    let sections: [Section]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sections = try container.decode([Section].self, forKey: .sections)
    }

    private enum CodingKeys: String, CodingKey {
        case sections = "data"
    }
}
