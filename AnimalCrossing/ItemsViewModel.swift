//
//  ItemsViewModel.swift
//  AnimalCrossing
//
//  Created by Tri Le on 11/20/23.
//

import Foundation
import Combine

public struct ItemResponse: Codable {
    let total: Int
    let results: [Item]
}

public struct Item: Codable, Identifiable {
    public var id: String { name }
    
    let name: String
    let image: String?
    let obtainedFrom: String?
    let dIY: Bool?
    let customize: Bool?
    
    let buy: Int?
    let sell: Int?
    
    let set: String?
}

class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = []
    
    private var apiPubisher: AnyPublisher<ItemResponse, Never>?
    
}

/**
 //
 //  ItemsViewModel.swift
 //  ACHNBrowserUI
 //
 //  Created by Thomas Ricouard on 08/04/2020.
 //  Copyright © 2020 Thomas Ricouard. All rights reserved.
 //

 import Foundation
 import Combine

 class ItemsViewModel: ObservableObject {
     @Published var items: [Item] = []
     @Published var searchItems: [Item] = []
     @Published var searchText = ""
     
     var currentFilter = APIService.Endpoint.housewares {
         didSet {
             items = []
             fetch()
         }
     }
     
     private var apiPublisher: AnyPublisher<ItemResponse, Never>?
     private var searchCancellable: AnyCancellable?
     private var apiCancellable: AnyCancellable? {
         willSet {
             apiCancellable?.cancel()
         }
     }
     
     init() {
         searchCancellable = _searchText
             .projectedValue
             .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
             .removeDuplicates()
             .sink { [weak self] string in
                 if !string.isEmpty {
                     self?.searchItems = self?.items.filter({ $0.name.contains(string) }) ?? []
                 }
         }
     }
     
     func fetch() {
         apiPublisher = APIService.fetch(endpoint: currentFilter)
             .replaceError(with: ItemResponse(total: 0, results: []))
             .eraseToAnyPublisher()
         apiCancellable = apiPublisher?
             .map{ $0.results }
             .receive(on: DispatchQueue.main)
             .assign(to: \.items, on: self)
     }
 }
 */
