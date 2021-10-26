//
//  DataController.swift
//  CryptoTracker
//
//  Created by Leo Kim on 22/10/2021.
//

import SwiftUI
import CoreData

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer

    init() {
        container = NSPersistentCloudKitContainer(name: "PortfolioCoreData", managedObjectModel: Self.model)

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "PortfolioCoreData", withExtension: "momd") else {
            fatalError("Failed to load model from file")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file")
        }

        return managedObjectModel
    }()

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(portfolio: NSManagedObject) {
        container.viewContext.delete(portfolio)
        save()
    }

    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Portfolio.fetchRequest()
        delete(fetchRequest)
    }

    func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        if let delete = try?
            container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }

    func add(coin: CoinModel, amount: Double) {
        let portfolio = Portfolio(context: container.viewContext)
        portfolio.coinID = coin.id
        portfolio.amount = amount
        save()
    }

    func update(portfolio: Portfolio, amount: Double) {
        portfolio.amount = amount
        save()
    }
}
