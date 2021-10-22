//
//  NetworkRepository.swift
//  GameLog
//
//  Created by duckbok on 2021/10/05.
//

import UIKit

struct NetworkRepository {

    typealias TaskResult = Result<(response: HTTPURLResponse, data: Data?), NetworkRepository.Error>

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
        guard let url = URL(base: baseURL, path: path, query: query) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        addUserSession(to: &request)

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

    func post<ResponseType: Decodable>(path: String,
                                       bodyType: BodyType,
                                       completion: @escaping (Result<ResponseType, Self.Error>) -> Void) {
        guard let url = URL(base: baseURL, path: path),
              var request = bodyType.urlRequest(url: url) else { return }

        request.httpMethod = "POST"
        addUserSession(to: &request)

        session.dataTask(with: request) { data, response, error in
            checkSessionResult(data, response, error) { taskResult in
                switch taskResult {
                case let .success((response, data)):
                    guard let responsedData = data else {
                        completion(.failure(.dataNotFound))
                        return
                    }
                    guard let decodedData = try? decoder.decode(ResponseType.self, from: responsedData) else {
                        completion(.failure(.dataNotDecodable))
                        return
                    }
                    if let fields = response.allHeaderFields as? [String: String] {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response.url!)
                        cookies.forEach { UserDefaults.standard.set( $0.value, forKey: $0.name) }
                    }

                    completion(.success(decodedData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func put<ResponseType: Decodable>(path: String,
                                      bodyType: BodyType,
                                      completion: @escaping (Result<ResponseType, Self.Error>) -> Void) {
        guard let url = URL(base: baseURL, path: path),
              var request = bodyType.urlRequest(url: url) else { return }

        request.httpMethod = "PUT"
        addUserSession(to: &request)

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
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    func delete(path: String,
                bodyType: BodyType? = nil,
                completion: @escaping (Result<ResponseMessage, Self.Error>) -> Void) {
        guard let url = URL(base: baseURL, path: path) else { return }

        var request: URLRequest

        if let bodyType = bodyType,
           let bodyRequest = bodyType.urlRequest(url: url) {
            request = bodyRequest
        } else {
            request = URLRequest(url: url)
        }
        request.httpMethod = "DELETE"
        addUserSession(to: &request)

        session.dataTask(with: request) { data, response, error in
            checkSessionResult(data, response, error) { taskResult in
                switch taskResult {
                case let .success((_, data)):
                    guard let responsedData = data else {
                        completion(.failure(.dataNotFound))
                        return
                    }
                    guard let decodedData = try? decoder.decode(ResponseMessage.self, from: responsedData) else {
                        completion(.failure(.dataNotDecodable))
                        return
                    }

                    completion(.success(decodedData))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    private func addUserSession(to request: inout URLRequest) {
        if let loginCookieValue = UserDefaults.standard.value(forKey: "connect.sid") as? String {
            request.addValue("connect.sid=\(loginCookieValue)", forHTTPHeaderField: "Cookie")
        }
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

// MARK: - Body Type

extension NetworkRepository {

    enum BodyType {
        case urlencoded(body: [String: String])

        func urlRequest(url: URL) -> URLRequest? {
            switch self {
            case let .urlencoded(body):
                guard let bodyData = String(body).data(using: .utf8) else { return nil }

                var request = URLRequest(url: url)
                request.httpBody = bodyData
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue(bodyData.count.description, forHTTPHeaderField: "Content-Length")
                return request
            }
        }
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
