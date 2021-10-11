//
//  NetworkRepository.swift
//  GameLog
//
//  Created by duckbok on 2021/10/05.
//

import Foundation

struct NetworkRepository {

    private enum EndPoint { }

    private let baseURL: String = "ec2-18-219-79-225.us-east-2.compute.amazonaws.com:3000/"

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }
}
