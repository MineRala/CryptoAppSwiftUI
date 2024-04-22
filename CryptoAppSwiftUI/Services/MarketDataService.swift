//
//  MarketDataService.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 18.04.2024.
//

import Foundation
import Combine

final class MarketDataService {
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    init() {
        // bunu bir yerde çağırsa bile marketData dinleyen her yerde data güncellenir.
        getData()
    }
    
    func getData() {        
        marketDataSubscription = NetworkingManager.download(urlString: URLs.marketDataURL.urlString)
            .decode(type: GloabalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] globalData in
                guard let self else { return }
                self.marketData = globalData.data
                self.marketDataSubscription?.cancel()
            })
    }
}
