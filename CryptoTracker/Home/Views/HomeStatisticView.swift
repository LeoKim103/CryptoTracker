//
//  HomeStatisticView.swift
//  CryptoTracker
//
//  Created by Leo Kim on 19/10/2021.
//

import SwiftUI

struct HomeStatisticView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortfolio: Bool

    var body: some View {
        HStack {
            ForEach(viewModel.statistics, content: StatisticView.init)
                .frame(width: UIScreen.main.bounds.width / 3)
        }
        .frame(
            width: UIScreen.main.bounds.width,
            alignment: showPortfolio ? .trailing : .leading
        )
    }
}

struct HomeStatisticView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatisticView(showPortfolio: .constant(false))
            .environmentObject(HomeViewModel())
    }
}
