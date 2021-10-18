//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Leo Kim on 18/10/2021.
// swiftlint:disable line_length

import Foundation
import Combine

class CoinDataService {
    var cancellables = Set<AnyCancellable>()

    @Published var allCoins = [CoinModel]()

    private var coinSubscription: AnyCancellable?

    init() {
        getCoin()
    }

    func getCoin() {
        guard let url = URL(
            string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else { return }

        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
}
