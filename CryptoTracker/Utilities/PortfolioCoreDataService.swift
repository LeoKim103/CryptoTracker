//
//  PortfolioCoinService.swift
//  CryptoTracker
//
//  Created by Leo Kim on 22/10/2021.
//

import Foundation
import CoreData

class PortfolioCoreDataService: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    let dataController: DataController

    private let portfolioController: NSFetchedResultsController<Portfolio>

    @Published var savedPortfolios = [Portfolio]()

    init(dataController: DataController) {
        self.dataController = dataController

        let request: NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Portfolio.coinID, ascending: false)]

        portfolioController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: dataController.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)

        super.init()
        portfolioController.delegate = self

        do {
            try portfolioController.performFetch()
            savedPortfolios = portfolioController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch user portfolio")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newPortfolios = controller.fetchedObjects as? [Portfolio] {
            savedPortfolios = newPortfolios
        }
    }

    func updatePortfolio(coin: CoinModel, amount: Double) {
        if let portfolio = savedPortfolios.first(where: { $0.coinID == coin.id}) {
            if amount > 0 {
                dataController.update(portfolio: portfolio, amount: amount)
            } else {
                dataController.delete(portfolio: portfolio)
            }
        } else {
            dataController.add(coin: coin, amount: amount)
        }
    }
}
