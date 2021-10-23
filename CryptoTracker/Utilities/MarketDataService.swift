//
//  MarketDataService.swift
//  CryptoTracker
//
//  Created by Leo Kim on 19/10/2021.
//

import Foundation
import Combine

class MarketDataService {
    var cancellables = Set<AnyCancellable>()

    @Published var marketData: MarketDataModel?

    private var marketDataSubscription: AnyCancellable?

    init() {
        getData()
    }

    func getData() {
        guard let url = URL(
            string: "https://api.coingecko.com/api/v3/global")
        else { return }

        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
