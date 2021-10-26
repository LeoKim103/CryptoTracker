//
//  SettingView.swift
//  CryptoTracker
//
//  Created by Leo Kim on 24/10/2021.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var showingDeletionConfirm = false

    let githubURL = URL(string: "https://github.com/LeoKim103")!
    let coinGeckoURL = URL(string: "https://www.coingecko.com")!

    var body: some View {
        NavigationView {
            ZStack {
                GlassMorphismView()

                List {
                    coinGeckoSection
                        .listRowBackground(GlassMorphismView())

                    developerSection
                        .listRowBackground(GlassMorphismView())

                    deleteAllDataSection
                        .listRowBackground(GlassMorphismView())

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
                .alert(isPresented: $showingDeletionConfirm) {
                    Alert(
                        title: Text("Delete all saved data?".uppercased()),
                        message: Text("Are you sure you want to delete all saved coins?"),
                        primaryButton: .default(Text("Delete"), action: delete),
                        secondaryButton: .cancel())
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(DataController())
            .preferredColorScheme(.dark)
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

    private var deleteAllDataSection: some View {
        Section {
            Button {
                showingDeletionConfirm.toggle()
            } label: {
                Text("Delete all saved data".uppercased())
                    .foregroundColor(Color.red)
            }
        } header: {
            Text("User data")
        }
    }

    private func delete() {
        dataController.deleteAll()
        presentationMode.wrappedValue.dismiss()
    }
}
