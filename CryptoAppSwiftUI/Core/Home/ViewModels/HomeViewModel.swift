//
//  HomeViewModel.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 10.04.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject  {
    @Published var statistics = [
        StatisticModel(title: "Title", value: "Value", percentageChanged: 1),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value", percentageChanged: -7)
    ]
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancallables = Set<AnyCancellable>()
    
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.$allCoins
            .sink { [weak self] coins in
                guard let self else { return }
                self.allCoins = coins
            }
            .store(in: &cancallables)
        
        $searchText
        /// 2 publisher'ı birleştirmek için combine latest kullanılır. Son yayınlanan değeri alır.
            .combineLatest(dataService.$allCoins)
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
}
