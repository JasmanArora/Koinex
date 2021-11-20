//
//  CoinModel.swift
//  Koinex
//
//  Created by Jasman Arora on 10/26/21.
//

import Foundation

//https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false
/*
{
    "id": "bitcoin",
    "symbol": "btc",
    "name": "Bitcoin",
    "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
    "current_price": 60926,
    "market_cap": 1147628467574,
    "market_cap_rank": 1,
    "fully_diluted_valuation": 1278153842268,
    "total_volume": 33755024874,
    "high_24h": 63379,
    "low_24h": 60290,
    "price_change_24h": -2226.519857794498,
    "price_change_percentage_24h": -3.52562,
    "market_cap_change_24h": -40178177245.673584,
    "market_cap_change_percentage_24h": -3.38255,
    "circulating_supply": 18855475,
    "total_supply": 21000000,
    "max_supply": 21000000,
    "ath": 67277,
    "ath_change_percentage": -9.3242,
    "ath_date": "2021-10-20T14:54:17.702Z",
    "atl": 67.81,
    "atl_change_percentage": 89864.11244,
    "atl_date": "2013-07-06T00:00:00.000Z",
    "roi": null,
    "last_updated": "2021-10-27T03:58:44.535Z"
  }
*/


struct CoinModel:  Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24H"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        
    }
  
}
