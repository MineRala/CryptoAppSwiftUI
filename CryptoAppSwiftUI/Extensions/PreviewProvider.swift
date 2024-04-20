//
//  PreviewProvider.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 10.04.2024.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    private init() {}
    
    let homeVM = HomeViewModel()
    
    let coin = CoinModel(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
        currentPrice: 61408,
        marketCap: 1141731099010,
        marketCapRank: 1,
        fullyDilutedValuation: 1285385611303,
        totalVolume: 67190952980,
        high24H: 61712,
        low24H: 56220,
        priceChange24H: 3952.64,
        priceChangePercentage24H: 6.87944,
        marketCapChange24H: 72110681879,
        marketCapChangePercentage24H: 6.74171,
        circulatingSupply: 18653043,
        totalSupply: 21000000,
        maxSupply: 21000000,
        ath: 61712,
        athChangePercentage: -0.97589,
        athDate: "2021-03-13T20:49:26.606Z",
        atl: 67.81,
        atlChangePercentage: 90020.24075,
        atlDate: "2013-07-06T00:00:00.000Z",
        lastUpdated: "2021-03-13T23:18:10.268Z",
        sparklineIn7D: SparklineIn7D(price: [
            54019.28678317463,
            53718.060935791254,
            53677.12968669343,
            53848.3814432924,
            54019.28678317463,
            53718.060935791254,
            53677.12968669343,
            53848.3814432924,
            54019.28678317463,
            53718.060935791254,
            53677.12968669343,
            53848.3814432924,
            54019.28678317463,
            53718.060935791254,
            53677.12968669343,
            53848.3814432924,
            54019.28678317463,
            53718.060935791254,
            53677.12968669343,
            53848.3814432924,
            54019.28678317463,
            53718.060935791254,
            53677.12968669343,
            53848.3814432924,
            59353.3535324167,
            69149.58289510019,
            54019.28678317463,
            53718.060935791254,
            53677.12968669343,
            53848.3814432924,
            54019.28678317463,
            53718.060935791254,
            53677.12968669343,
            53848.3814432924,
            54019.28678317463,
            53718.060935791254,
            53677.12968669343,
            45255.50258150810,
            53848.3814432924,
            54019.28678317463,
            53718.060935791254,
            53677.12968669343,
            53848.3814432924
        ]),
        priceChangePercentage24HInCurrency: 3952.64,
        currentHoldings: 1.5
    )
    
    let stat1 = StatisticModel(
        title: "Market Cap",
        value: "$12.5Bn",
        percentageChanged: 25.34
    )
    
    let stat2 = StatisticModel(
        title: "Total Volume",
        value: "$1.23Tr"
    )
    
    let stat3 = StatisticModel(
        title: "Portfolio Value",
        value: "$50.4k",
        percentageChanged: -12.34
    )
}
