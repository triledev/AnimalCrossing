//
//  APIService.swift
//  AnimalCrossing
//
//  Created by Tri Le on 11/20/23.
//

import Foundation
import Combine

struct APIService {
    enum Endpoint: String, CaseIterable {
        case housewares, miscellaneous
        case wallMounted = "wall-mounted"
        case wallpaper, floors, rugs, photos, posters, fencing, tools
        case tops, bottoms, dresses, headwear, accessories, socks, shoes, bags
        case umbrellas, songs, recipes, fossils, construction, nookmiles, other
    }
    
    enum APIError: Error {
        case unknown
        case message(reason: String), parseError(reason: String), networkError(reason: String)
    }
    
    static let BASE_URL = URL(string: "https://acnhapi.com/v1/")!

    private static let decoder = JSONDecoder()

    static func makeURL(endpoint: Endpoint) -> URL {
        let component = URLComponents(url: BASE_URL.appendingPathComponent(endpoint.rawValue), resolvingAgainstBaseURL: false)!
        return component.url!
    }
    
    static func fetch<T: Codable>(endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        let request = URLRequest(url: makeURL(endpoint: endpoint))
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown
                }
                if (httpResponse.statusCode == 404) {
                    throw APIError.message(reason: "Resource not found")
                }
                return data
            }
            .decode(type: T.self, decoder: APIService.decoder)
            .mapError { APIError.parseError(reason: $0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}
