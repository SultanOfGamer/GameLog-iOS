//
//  NetworkRepository.swift
//  GameLog
//
//  Created by duckbok on 2021/10/05.
//

import UIKit

struct NetworkRepository {

    typealias TaskResult = Result<(response: HTTPURLResponse, data: Data?), NetworkRepository.Error>

    private let baseURL: String = "http://ec2-18-219-79-225.us-east-2.compute.amazonaws.com:3000"
    private let session: URLSession
    private let okStatusCodes: ClosedRange<Int> = (200...299)

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - HTTP Methods

    func get<ResponseType: Decodable>(path: String? = nil,
                                      query: (key: String, value: String)? = nil,
                                      completion: @escaping (Result<ResponseType, Self.Error>) -> Void) {
        let pathString: String = (path == nil) ? "" : "/\(path!)"
        let queryString: String = (query == nil) ? "" : "?\(query!.key)=\(query!.value)"
        guard let url = URL(string: baseURL + pathString + queryString) else { return }

        session.dataTask(with: url) { data, response, error in
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
