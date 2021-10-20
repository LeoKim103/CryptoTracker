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
    @Published var sortOptions: SortOptions = .rank
    @Published var isLoading: Bool = false

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()

    enum SortOptions {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }

    init() {
        addSubscriber()
    }

    func addSubscriber() {

        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOptions)
            .map(filteredAndSortCoins)
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

    private func filteredAndSortCoins(text: String, coins: [CoinModel], sort: SortOptions) -> [CoinModel] {
        var updatedCoins = filteredCoins(text: text, coins: coins)
        sortCoins(sort: sort, coin: &updatedCoins)
        return updatedCoins
    }

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

    private func sortCoins(sort: SortOptions, coin: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coin.sort(by: { $0.rank < $1.rank})
        case .rankReversed, .holdingsReversed:
            coin.sort(by: { $0.rank > $1.rank})
        case .price:
            coin.sort(by: { $0.currentPrice > $1.currentPrice})
        case .priceReversed:
            coin.sort(by: { $0.currentPrice < $1.currentPrice})
        }
    }

    func reloadData() {
        isLoading = true
        coinDataService.getCoin()
        marketDataService.getData()
    }
}
