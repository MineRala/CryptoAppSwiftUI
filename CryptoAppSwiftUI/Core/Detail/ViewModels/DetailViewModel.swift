//
//  DetailViewModel.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 20.04.2024.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .sink { details in
                print("Received coin detail data")
                print(details)
            }
            .store(in: &cancellables)
    }
}
