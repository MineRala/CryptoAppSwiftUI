//
//  URLs.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 22.04.2024.
//

import Foundation

enum URLs {
    case coinDataURL
    case coinImageURL(coinImage: String)
    case marketDataURL
    case coinDetailURL(coinID: String)
    
    var urlString: String {
        switch self {
        case .coinDataURL:
            return "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
        case .coinImageURL(let coinImage):
            return coinImage
        case .marketDataURL:
            return "https://api.coingecko.com/api/v3/global"
        case .coinDetailURL(let coinID):
            return "https://api.coingecko.com/api/v3/coins/\(coinID)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
        }
    }
}
