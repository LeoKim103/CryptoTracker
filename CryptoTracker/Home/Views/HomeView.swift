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
    @State private var showPortfolioView: Bool = false
    @State private var showDetailView: Bool = false
    @State private var selectedCoin: CoinModel?

    var body: some View {
        ZStack {
            // Background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(viewModel)
                }

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
                NavigationLink(
                    destination: DetailLoadingView(coin: $selectedCoin),
                    isActive: $showDetailView,
                    label: {
                        EmptyView()
                    })
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(HomeViewModel(dataController: DataController()))
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        // show setting view
                    }
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
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())
    }

    private var portfolioEmptyText: some View {
        Text("You haven't added any coin to your portfolio yet. Click the + button to add coin.")
            .font(.callout)
            .fontWeight(.medium)
            .foregroundColor(Color.theme.accent)
            .multilineTextAlignment(.center)
            .padding(50)
    }

    private var portfolioCoinList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showingHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }

    private func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
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
                        .opacity((viewModel.sortOptions == .holdings || viewModel.sortOptions == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: viewModel.sortOptions == .holdings ? 0 : 180))

                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOptions = viewModel.sortOptions == .holdings ? .holdingsReversed : .holdings
                    }
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
