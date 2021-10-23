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
        container = NSPersistentCloudKitContainer(name: "PortfolioCoreData")

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(portfolio: Portfolio) {
        container.viewContext.delete(portfolio)
    }
}
