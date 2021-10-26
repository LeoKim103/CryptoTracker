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

    @State private var showLaunchView: Bool = true

    init() {
        let viewModel = HomeViewModel(dataController: DataController())
        let dataController = DataController()

        _viewModel = StateObject(wrappedValue: viewModel)
        _dataController = StateObject(wrappedValue: dataController)

        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UITableView.appearance().backgroundColor = UIColor.clear
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationView {
                    HomeView()
                        .environment(\.managedObjectContext, dataController.container.viewContext)
                        .environmentObject(viewModel)
                        .environmentObject(dataController)
                        .navigationBarHidden(true)
                        .onReceive(
                            NotificationCenter.default.publisher(
                                for: UIApplication.willResignActiveNotification),
                                perform: save)
                }
                .navigationViewStyle(StackNavigationViewStyle())

                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                    }
                }
                .zIndex(2.0)
            }
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
