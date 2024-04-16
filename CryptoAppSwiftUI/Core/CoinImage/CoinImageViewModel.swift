//
//  CoinImageViewModel.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 16.04.2024.
//

import Foundation
import SwiftUI
import Combine

final class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false

    private let coin: CoinModel
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers() {
        dataService.$image
            .sink { [weak self] (_) in
                guard let self else { return }
                self.isLoading = false
            } receiveValue: { [weak self] image in
                guard let self else { return }
                self.image = image
            }
            .store(in: &cancellables)
    }
}
