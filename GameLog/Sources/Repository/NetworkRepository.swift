//
//  NetworkRepository.swift
//  GameLog
//
//  Created by duckbok on 2021/10/05.
//

import UIKit

struct NetworkRepository {

    typealias TaskResult = Result<(response: HTTPURLResponse, data: Data?), NetworkRepository.Error>
    typealias PostResult = Result<(message: String?, cookies: [HTTPCookie]?), NetworkRepository.Error>

    static let shared = NetworkRepository()

    private let baseURL: String = "http://ec2-18-219-79-225.us-east-2.compute.amazonaws.com:3000"
    private let session: URLSession
    private let okStatusCodes: ClosedRange<Int> = (200...299)

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - HTTP Methods

    func get<ResponseType: Decodable>(path: String? = nil,
                                      query: [String: String]? = nil,
                                      completion: @escaping (Result<ResponseType, Self.Error>) -> Void) {
        let pathString: String = (path == nil) ? "" : "/\(path!)"
        let queryString: String = (query == nil) ? "" : "?\(parameterString(by: query!))"

        guard let url = URL(string: baseURL + pathString + queryString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let loginCookieValue = UserDefaults.standard.value(forKey: "connect.sid") as? String {
            request.addValue("connect.sid=\(loginCookieValue)", forHTTPHeaderField: "Cookie")
        }

        session.dataTask(with: request) { data, response, error in
            checkSessionResult(data, response, error) { taskResult in
                switch taskResult {
                case let .success((_, data)):
                    guard let responsedData = data else {
                        completion(.failure(.dataNotFound))
                        return
                    }
                    guard let decodedData = try? decoder.decode(ResponseType.self, from: responsedData) else {
                        completion(.failure(.dataNotDecodable))
                        return
                    }
                    completion(.success(decodedData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func post(path: String, bodies: [String: String], completion: @escaping (PostResult) -> Void) {
        let pathString: String = "/\(path)"
        guard let url = URL(string: baseURL + pathString),
              let bodyData = parameterString(by: bodies).data(using: .utf8) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(bodyData.count.description, forHTTPHeaderField: "Content-Length")

        if let loginCookieValue = UserDefaults.standard.value(forKey: "connect.sid") as? String {
            request.addValue("connect.sid=\(loginCookieValue)", forHTTPHeaderField: "Cookie")
        }

        session.dataTask(with: request) { data, response, error in
            checkSessionResult(data, response, error) { taskResult in
                switch taskResult {
                case let .success((response, data)):
                    guard let responsedData = data else {
                        completion(.failure(.dataNotFound))
                        return
                    }
                    guard let jsonObject = try? JSONSerialization.jsonObject(with: responsedData, options: []),
                          let decodedData = jsonObject as? [String: String],
                          let message = decodedData["message"] else {
                              completion(.failure(.dataNotDecodable))
                              return
                    }

                    if let fields = response.allHeaderFields as? [String: String] {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response.url!)
                        completion(.success((message, cookies)))
                    } else {
                        completion(.success((message, nil)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    private func checkSessionResult(_ data: Data?, _ response: URLResponse?, _ error: Swift.Error?,
                                    completion: @escaping ((TaskResult) -> Void)) {
        if let error = error {
            completion(.failure(.requestFailed(error)))
            return
        }

        guard let response = response as? HTTPURLResponse else { return }

        guard okStatusCodes.contains(response.statusCode) else {
            completion(.failure(.responseNotOK(response.statusCode)))
            return
        }

        completion(.success((response, data)))
    }

    private func parameterString(by bodies: [String: String]) -> String {
        var bodyString = String()
        for body in bodies {
            bodyString += "\(body.key)=\(body.value)&"
        }
        bodyString.removeLast()
        return bodyString
    }
}

// MARK: - Error

extension NetworkRepository {

    enum Error: Swift.Error {
        case dataNotFound
        case dataNotDecodable
        case requestFailed(Swift.Error)
        case responseNotOK(Int)
    }
}

// MARK: - Type Method

extension NetworkRepository {

    @discardableResult
    static func fetchImage(from urlString: String, completion: @escaping (UIImage) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else { return nil }

        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            completion(image)
        }
        dataTask.resume()
        return dataTask
    }
}
