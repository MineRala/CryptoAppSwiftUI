//
//  HomeViewModel.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 10.04.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject  {
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancallables = Set<AnyCancellable>()
    
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDataService.$allCoins
            .sink { [weak self] coins in
                guard let self else { return }
                self.allCoins = coins
            }
            .store(in: &cancallables)
        
        marketDataService.$marketData
        /// MarketDataModeli alıp Statistic model'e çevirip(transform) setliyor.
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                guard let self else { return }
                self.statistics = stats
            }
            .store(in: &cancallables)
        
        $searchText
        /// 2 publisher'ı birleştirmek için combine latest kullanılır. Son yayınlanan değeri alır.
            .combineLatest(coinDataService.$allCoins)
        /// yayınlanan değerler arasında bir gecikme (delay) ekler. Bu durumda, arama metni her değiştiğinde işlemin tetiklenmesini biraz geciktirir. Bu, kullanıcı arama metnini hızlıca değiştiriyorsa, her bir değişikliğin hemen işlenmesini önler ve yalnızca belirli bir süre boyunca değişiklik yapılmadığında işlemi gerçekleştirir. Bu, gereksiz iş yükünü azaltmak ve daha verimli bir kullanıcı deneyimi sağlamak için kullanılır.
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] coins in
                guard let self else { return }
                self.allCoins = coins
            }
            .store(in: &cancallables)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) || coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobalMarketData(data: MarketDataModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data else { return stats }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChanged: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChanged: 0)
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
