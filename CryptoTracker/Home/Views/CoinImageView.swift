//
//  CoinImageView.swift
//  CryptoTracker
//
//  Created by Leo Kim on 20/10/2021.
//
import Foundation
import SwiftUI
import Combine

struct CoinImageView: View {
    @StateObject var viewModel: CoinImageViewModel

    init(coin: CoinModel) {
        let viewModel = CoinImageViewModel(coin: coin)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
