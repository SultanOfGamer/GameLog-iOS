//
//  URL+extension.swift
//  GameLog
//
//  Created by duckbok on 2021/10/19.
//

import Foundation

extension URL {

    init?(base: String, path: String? = nil, query: [String: String]? = nil) {
        if let path = path,
           let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
            if let query = query,
               let encodedQuery = String(query).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                self.init(string: base + "/" + encodedPath + "?" + encodedQuery)
            } else {
                self.init(string: base + "/" + encodedPath)
            }
        } else {
            self.init(string: base)
        }
    }
}
