//
//  HomeView.swift
//  CryptoTracker
//
//  Created by Leo Kim on 18/10/2021.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var showPortfolio: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background layer
                Color.theme.background
                    .ignoresSafeArea()

                // Content layer
                VStack {
                    homeHeader

                    HomeStatisticView(showPortfolio: $showPortfolio)

                    SearchBarView(searchText: $viewModel.searchText)

                    columnTitles

                    if !showPortfolio {
                        allCoinsList
                            .transition(.move(edge: .leading))
                    } else {
                        ZStack(alignment: .top) {
                            portfolioCoinList
                        }
                    }
                    Spacer(minLength: 0)
                }
                .background(
                    NavigationLink(destination: CoinDetailView(), label: {
                        EmptyView()
                    })
                )
            }
            .navigationBarHidden(true)
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewModel())
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    // more to come
                }
                .background(CircleButtonAnimation(animate: $showPortfolio))

            Spacer()

            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)

            Spacer()

            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }

    private var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin, showingHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        // more to come 
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }

    private var portfolioCoinList: some View {
        Text("Portfolio Coinlist")
    }

    private var columnTitles: some View {
        HStack {
            HStack {
                Text("Coin")

                Image(systemName: "chevron.down")
                    .opacity(
                        (viewModel.sortOptions == .rank || viewModel.sortOptions == .rankReversed) ?
                        1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: viewModel.sortOptions == .rank ? 0: 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOptions = viewModel.sortOptions == .rank ?
                        .rankReversed : .rank
                }
            }

            Spacer()

            if showPortfolio {
                HStack {
                    Text("Holding")

                    Image(systemName: "chevron.down")

                }
                .onTapGesture {
                    // more to come 
                }
            }

            HStack {
                Text("Price")

                Image(systemName: "chevron.down")
                    .opacity(
                        (viewModel.sortOptions == .price || viewModel.sortOptions == .priceReversed) ?
                        1.0 : 0.0
                    )
                    .rotationEffect(Angle(degrees: viewModel.sortOptions == .price ? 0: 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOptions = viewModel.sortOptions == .price ?
                        .priceReversed : .price
                }
            }

            Button {
                withAnimation(.linear(duration: 2.0)) {
                    viewModel.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: viewModel.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
