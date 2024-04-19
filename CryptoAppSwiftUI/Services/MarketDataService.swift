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
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GloabalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] globalData in
                guard let self else { return }
                self.marketData = globalData.data
                self.marketDataSubscription?.cancel()
            })
    }
}
