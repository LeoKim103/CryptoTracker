//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Leo Kim on 18/10/2021.
//

import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var allCoins = [CoinModel]()
    @Published var portfolioCoins = [CoinModel]()
    @Published var statistics = [StatisticModel]()
    @Published var searchText = ""
    @Published var sortOptions: SortOptions = .rank
    @Published var isLoading: Bool = false

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioViewModel: PortfolioViewModel
    private var cancellables = Set<AnyCancellable>()

    enum SortOptions {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }

    init(dataController: DataController) {
        portfolioViewModel = PortfolioViewModel(dataController: dataController)
        addSubscriber()
    }

    func addSubscriber() {

        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOptions)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filteredAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)

        $allCoins
            .combineLatest(portfolioViewModel.$savedPortfolios)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coin: returnedCoins)
            }
            .store(in: &cancellables)

        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
    }

    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolios: [Portfolio]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolios.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHolding(amount: entity.amount)
            }

    }

    private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel] {
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

        let portfolioValue =
                    portfolioCoins
                        .map({ $0.currentHoldingValue})
                        .reduce(0, +)

        let previousValue =
                    portfolioCoins
                        .map { (coin) -> Double in
                            let currentValue = coin.currentHoldingValue
                            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                            let previousValue = currentValue / (1 + percentChange)
                            return previousValue
                        }
                        .reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100

        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)

        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])

        return stats
    }

     private func filteredAndSortCoins(text: String, coins: [CoinModel], sort: SortOptions) -> [CoinModel] {
        var updatedCoins = filteredCoins(text: text, coins: coins)
        sortCoins(sort: sort, coin: &updatedCoins)
        return updatedCoins
    }

     private func sortPortfolioCoinsIfNeeded(coin: [CoinModel]) -> [CoinModel] {
        switch sortOptions {
        case .holdings:
            return coin.sorted(by: { $0.currentHoldingValue > $1.currentHoldingValue})
        case .holdingsReversed:
            return coin.sorted(by: { $0.currentHoldingValue < $1.currentHoldingValue})
        default:
            return coin
        }
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

    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioViewModel.updatePortfolio(coin: coin, amount: amount)
    }

    func reloadData() {
        isLoading = true
        coinDataService.getCoin()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
}
