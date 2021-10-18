//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Leo Kim on 18/10/2021.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    @StateObject var viewModel: HomeViewModel

    init() {
        let viewModel = HomeViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(viewModel)
        }
    }
}
