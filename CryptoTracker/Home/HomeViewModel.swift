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

    private let coinDataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscriber()
    }

    func addSubscriber() {
        coinDataService.$allCoins
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}
