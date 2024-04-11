//
//  HomeViewModel.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 10.04.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject  {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
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
    }
}
