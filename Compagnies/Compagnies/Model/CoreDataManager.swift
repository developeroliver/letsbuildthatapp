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
    
    func fetchCompanies() -> [Company] {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchError{
            print("Failed to fetch companies:", fetchError)
            return []
        }
    }
    
    func resetCompanies(completion: () -> ()) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createEmployee(employeeName: String) -> Error? {
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
        
        employee.setValue(employeeName, forKey: "name")
        
        do {
            try context.save()
            return nil
        } catch let saveError {
            return saveError
            print("Failed to create employee:", saveError)
        }
    }
}
