//
//  CoinDataService.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 10.04.2024.
//

import Foundation
import Combine

final class CoinDataService {
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        // bunu bir yerde çağırsa bile allcoinsi dinleyen her yerde coinler güncellenir.
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] coins in
                guard let self else { return }
                self.allCoins = coins
                self.coinSubscription?.cancel()
            })
    }
}
