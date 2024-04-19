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
    @Published var isLoading: Bool = false
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancallables = Set<AnyCancellable>()
    
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        // updates allCoins
        $searchText
        /// 2 publisher'ı birleştirmek için combine latest kullanılır. Son yayınlanan değeri alır.
        /// combineLatest operatörü, herhangi bir yayın değeri değiştiğinde çalışır. Bu nedenle, searchText yayını her değiştiğinde veya coinDataService.$allCoins yayını her değiştiğinde, combineLatest operatörü tetiklenir ve işlenir.
            .combineLatest(coinDataService.$allCoins)
        /// yayınlanan değerler arasında bir gecikme (delay) ekler. Bu durumda, arama metni her değiştiğinde işlemin tetiklenmesini biraz geciktirir. Bu, kullanıcı arama metnini hızlıca değiştiriyorsa, her bir değişikliğin hemen işlenmesini önler ve yalnızca belirli bir süre boyunca değişiklik yapılmadığında işlemi gerçekleştirir. Bu, gereksiz iş yükünü azaltmak ve daha verimli bir kullanıcı deneyimi sağlamak için kullanılır.
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] coins in
                guard let self else { return }
                self.allCoins = coins
            }
            .store(in: &cancallables)
        
        // updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] coins in
                guard let self else { return }
                self.portfolioCoins = coins
            }
            .store(in: &cancallables)
        
        // updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
        /// MarketDataModeli ve CoinModel'i  alıp Statistic model'e çevirip(transform) setliyor.
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                guard let self else { return }
                self.statistics = stats
                self.isLoading = false
            }
            .store(in: &cancallables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
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
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntites: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioEntites.first(where: { $0.coinID == coin.id }) else { return nil }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(data: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data else { return stats }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChanged: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolioValue = portfolioCoins.map({ $0.currentHoldingsValue }).reduce(0, +)
        let previousValue = portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
        }.reduce(0, +)
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChanged: percentageChange)
      
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
