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
    private let fileManager = LocalFileManager.instance
    private let folderNamge = "coin_images"
    private let imageName: String
    
    init (coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderNamge) {
            /// Bir kere api dan indirilince imagelar filemanager'a kaydedilir. Eğer file manager da image'ın dosyası varsa cachden okur yani fileManager dan tekrardan download işlemi gerçekleşmez.
            image = savedImage
            print("Retrieved image from File Manager!")
        } else {
            /// her image ilk kez buraya girer. ve api dan indirilir
            downloadCoinImage()
            print("Downloading image now")
        }
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] image in
                guard let self, let downloadedImage = image else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderNamge)
            })
    }
}
