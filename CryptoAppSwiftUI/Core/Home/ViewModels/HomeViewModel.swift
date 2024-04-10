//
//  HomeViewModel.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 10.04.2024.
//

import Foundation

final class HomeViewModel: ObservableObject  {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.allCoins.append(DeveloperPreview.instance.coin)
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
    }
}
