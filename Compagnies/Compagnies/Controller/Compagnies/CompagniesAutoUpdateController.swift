//
//  CompagniesAutoUpdateController.swift
//  Compagnies
//
//  Created by olivier geiger on 30/04/2024.
//

import UIKit
import CoreData

class CompagniesAutoUpdateController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    let reuseID = "CELL_ID"
    lazy var fetchedResultsController: NSFetchedResultsController<Company> = {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch let err {
            print(err)
        }
        
        return frc
    }()
    
    // MARK: - UI Declarations
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        setupNavigationItem()
        fetchedResultsController.fetchedObjects?.forEach({ company in
            print(company.name ?? "")
        })
    }
}

// MARK: - @objc Functions
extension CompagniesAutoUpdateController {
    
    @objc private func handleAdd() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let company = Company(context: context)
        company.name = "BMW"
        
        do {
            try context.save()
            tableView.reloadData()
        } catch let saveError {
            print("Failed to save company:", saveError)
        }
    }
}

// MARK: - Helpers
extension CompagniesAutoUpdateController {
    
    private func setup() {
        view.backgroundColor = UIColor.darkBlue
        title = "Company auto update"
    }
    
    private func  setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Ajouter", style: .plain, target: self, action: #selector(handleAdd))
    }
    
    private func setupTableView() {
        tableView.register(CompanyCell.self, forCellReuseIdentifier: reuseID)
    }
}

// MARK: - UITableView
extension CompagniesAutoUpdateController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! CompanyCell
        let company = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.tealColor
        
        cell.company = company
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
