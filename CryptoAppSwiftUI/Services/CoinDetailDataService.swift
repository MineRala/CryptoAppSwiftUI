//
//  CoinDetailDataService.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 20.04.2024.
//

import Foundation
import Combine

final class CoinDetailDataService {

    @Published var coinDetails: CoinDetailModel? = nil
    var coinDetailSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {
        coinDetailSubscription = NetworkingManager.download(urlString: URLs.coinDetailURL(coinID: coin.id).urlString)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] details in
                guard let self else { return }
                self.coinDetails = details
                self.coinDetailSubscription?.cancel()
            })
    }
}
