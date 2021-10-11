//
//  Date+formatter.swift
//  GameLog
//
//  Created by duckbok on 2021/10/11.
//

import Foundation

extension Date {

    var string: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
