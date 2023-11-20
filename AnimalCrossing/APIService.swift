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
}
