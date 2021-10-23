//
//  CoinDetailViewModel.swift
//  CryptoTracker
//
//  Created by Leo Kim on 21/10/2021.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    @Published var coin: CoinModel
    @Published var overviewStats = [StatisticModel]()
    @Published var additionalStats = [StatisticModel]()
    @Published var coinDescription: String?
    @Published var websiteURL: String?
    @Published var redditURL: String?

    private let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()

    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscriber()
    }

    private func addSubscriber() {
        coinDetailDataService.$coinDetails
            .sink { [weak self] (returnedCoinDetails) in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)

        coinDetailDataService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistic)
            .sink { [weak self] (returnedArrays) in
                self?.overviewStats = returnedArrays.overview
                self?.additionalStats = returnedArrays.additional
            }
            .store(in: &cancellables)
    }

    func mapDataToStatistic(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) ->
        (overview: [StatisticModel], additional: [StatisticModel]) {
            let overviewArray = createOverviewArray(coinModel: coinModel)
            let additionalArray = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)

            return (overviewArray, additionalArray)
    }

    func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)

        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalisation", value: marketCap,
                                           percentageChange: marketCapPercentChange)

        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)

        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)

        let overviewArray: [StatisticModel] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        return overviewArray
    }

    func createAdditionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24H High", value: high)

        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24H Low", value: low)

        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(
            title: "24H Price Change", value: priceChange, percentageChange: pricePercentChange)

        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(
            title: "24H Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)

        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)

        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing", value: hashing)

        let additionalArray: [StatisticModel] = [
            highStat, lowStat, priceChangeStat,
            marketCapChangeStat, blockStat, hashingStat
        ]
        return additionalArray
    }
}
