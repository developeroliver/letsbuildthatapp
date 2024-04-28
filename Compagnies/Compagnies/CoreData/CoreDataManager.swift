//
//  CoreDataManager.swift
//  Compagnies
//
//  Created by olivier geiger on 28/04/2024.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CompaniesModels")
        container.loadPersistentStores { NSPersistentStoreDescription, error in
            if let error = error {
                fatalError("Loading of store failed: \(error)")
            }
        }
        return container
    }()
}
