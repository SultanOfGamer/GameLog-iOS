//
//  String+extension.swift
//  GameLog
//
//  Created by duckbok on 2021/10/19.
//

extension String {

    init(_ dictionary: [String: String]) {
        var result = String()
        dictionary.forEach { result += "\($0.key)=\($0.value)&" }
        result.removeLast()
        self.init(result)
    }
}
