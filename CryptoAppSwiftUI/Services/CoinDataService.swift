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
    @Published var error: String?

    var coinSubscription: AnyCancellable?
    
    init() {
        // bunu bir yerde çağırsa bile allcoinsi dinleyen her yerde coinler güncellenir.
        getCoins()
    }
    
    func getCoins() {
        coinSubscription = NetworkingManager.download(urlString: URLs.coinDataURL.urlString)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if let networkingError = error as? NetworkingError {
                        self.error = networkingError.errorMessage
                    } else {
                        self.error = NetworkingError.unknown.errorMessage
                    }
                }
            }, receiveValue: { [weak self] coins in
                guard let self else { return }
                allCoins = coins
                coinSubscription?.cancel()
            })
    }
}
