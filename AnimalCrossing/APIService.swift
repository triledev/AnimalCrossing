//
//  APIService.swift
//  AnimalCrossing
//
//  Created by Tri Le on 11/20/23.
//

import Foundation
import Combine

struct APIService {
    enum Endpoint {
        case villagers
        case villagerIcon(id: Int)
        case villagerImage(id: Int)
        case songs
        case songsImage(id: Int)
        case music(id: Int)
        
        public func path() -> String {
            switch self {
            case .villagers:
                return "villagers"
            case let .villagerIcon(id):
                return "icons/villagers/\(id)"
            case let .villagerImage(id):
                return "images/villagers/\(id)"
            case .songs:
                return "songs"
            case let .songsImage(id):
                return "images/songs/\(id)"
            case let .music(id):
                return "music/\(id)"
            }
        }
    }
    
    enum APIError: Error {
        case unknown
        case message(reason: String), parseError(reason: String), networkError(reason: String)
        
        static func processResponse(data: Data, response: URLResponse) throws -> Data {
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }
            if (httpResponse.statusCode == 404) {
                throw APIError.message(reason: "Resource not found")
            }
            return data
        }
    }
    
    static let BASE_URL = URL(string: "https://acnhapi.com/v1/")!

    private static let decoder = JSONDecoder()

    static func makeURL(endpoint: Endpoint) -> URL {
        let component = URLComponents(url: BASE_URL.appendingPathComponent(endpoint.path()), resolvingAgainstBaseURL: false)!
        return component.url!
    }
    
    static func fetch<T: Codable>(endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        let request = URLRequest(url: makeURL(endpoint: endpoint))
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                return try APIError.processResponse(data: data, response: response)
            }
            .decode(type: T.self, decoder: Self.decoder)
            .mapError { APIError.parseError(reason: $0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}
