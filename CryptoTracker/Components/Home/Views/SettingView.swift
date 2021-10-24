//
//  SettingView.swift
//  CryptoTracker
//
//  Created by Leo Kim on 24/10/2021.
//

import SwiftUI

struct SettingView: View {
    let githubURL = URL(string: "https://github.com/LeoKim103")!
    let coinGeckoURL = URL(string: "https://www.coingecko.com")!

    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background.ignoresSafeArea()

                List {
                    coinGeckoSection
                        .listRowBackground(Color.theme.background.opacity(0.5))

                    developerSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                }
                .font(.headline)
                .accentColor(.blue)
                .listStyle(GroupedListStyle())
                .navigationTitle("About this app")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        XMarkButton()
                    }
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

extension SettingView {
    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Text("The app uses a free API from CoinGecko to fetch crypto currency data!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit Coin Gecko", destination: coinGeckoURL)

        } header: {
            Text("Coin Gecko")
        }
    }

    private var developerSection: some View {
        Section {
            Link("Developer website", destination: githubURL)
        } header: {
            Text("Application")
        }

    }
}
