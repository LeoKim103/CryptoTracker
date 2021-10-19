//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Leo Kim on 18/10/2021.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins = [CoinModel]()
    @Published var statistics = [StatisticModel]()
    @Published var searchText = ""

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscriber()
    }

    func addSubscriber() {

        $searchText
            .combineLatest(coinDataService.$allCoins)
            .map(filteredCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)

        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
    }

    func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel] {
        var stats = [StatisticModel]()

        guard let data = marketDataModel else {
            return stats
        }

        let marketCap = StatisticModel(
            title: "Market Cap",
            value: data.marketCap,
            percentageChange: data.marketCapChangePercentage24HUsd
        )

        let volume = StatisticModel(
            title: "24h Volume",
            value: data.volume
        )

        let btcDominance = StatisticModel(
            title: "BTC Dominance",
            value: data.btcDominance
        )

        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: "test",
            percentageChange: 100)

        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])

        return stats
    }

//    private func filteredAndSortCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
//        var updatedCoins = filter
//    }

    private func filteredCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercasedText = text.lowercased()
        return coins.filter { (coin) -> Bool in
            return
                coin.name.lowercased()
                    .contains(lowercasedText) ||
                coin.symbol.lowercased()
                    .contains(lowercasedText) ||
                coin.id.lowercased()
                    .contains(lowercasedText)
        }
    }
}
