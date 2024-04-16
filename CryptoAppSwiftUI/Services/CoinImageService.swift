//
//  CoinImageService.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 16.04.2024.
//

import Foundation
import SwiftUI
import Combine

final class CoinImageService {
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    
    init (coin: CoinModel) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] image in
                guard let self else { return }
                self.image = image
                self.imageSubscription?.cancel()
            })
    }
}
