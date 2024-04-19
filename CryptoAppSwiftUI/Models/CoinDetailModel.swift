//
//  CoinDetailModel.swift
//  CryptoAppSwiftUI
//
//  Created by Mine Rala on 20.04.2024.
//

import Foundation

/*
 URL:
    https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false
 */

// MARK: - CoinDetailModel
struct CoinDetailModel: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, description, links
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
    }
}

// MARK: - Links
struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?
    
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}

// MARK: - Description
struct Description: Codable {
    let en: String?
}
