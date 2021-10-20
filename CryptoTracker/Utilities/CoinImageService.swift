//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by Leo Kim on 20/10/2021.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    @Published var image: UIImage?

    private var imageSubcription: AnyCancellable?
    private let coin: CoinModel
    private let filManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String

    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        // fetch Image
        getCoinImage()
    }

    private func getCoinImage() {
        // fetch image from previously saved image
        if let savedImage = filManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            // if the image is not downloaded, download it now
            downloadCoinImage()
        }
    }

    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }

        imageSubcription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (returnedImage) in
                    guard let self = self, let downloadedImage = returnedImage else { return }

                    self.image = downloadedImage
                    self.imageSubcription?.cancel()
                    self.filManager.saveImage(
                        image: downloadedImage,
                        imageName: self.imageName,
                        folderName: self.folderName)
                })
    }
}
