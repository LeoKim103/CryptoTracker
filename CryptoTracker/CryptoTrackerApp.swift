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
    @StateObject var dataController: DataController

    init() {
        let viewModel = HomeViewModel(dataController: DataController())
        let dataController = DataController()

        _viewModel = StateObject(wrappedValue: viewModel)
        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(viewModel)
            .environmentObject(dataController)
        }
    }
}
