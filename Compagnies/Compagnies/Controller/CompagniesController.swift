//
//  CompagniesController.swift
//  Compagnies
//
//  Created by olivier geiger on 28/04/2024.
//

import UIKit
import CoreData

class CompagniesController: UITableViewController, CreateCompanyControllerDelegate {
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    // MARK: - Properties
    let reuseID = "CELL_ID"
    var companies = [Company]()
    var delegate: CreateCompanyControllerDelegate?
    
    // MARK: - UI
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationItem()
        setupTableView()
        layout()
        fetchCompanies()
    }
}

// MARK: - @objc Functions
extension CompagniesController {
    
    @objc func handleAddCompany() {
       let createCompanyController = CreateCompanyController()
        
        let navController = UINavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        
        present(navController, animated: true)
    }
    
    @objc func reset() {
        let alert = UIAlertController(title: "Réinitialisation data base", message: "Cette fonctionnalité n'est pas encore disponible.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func fetchCompanies() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            companies.forEach { company in
                print(company.name ?? "")
            }
            
            self.companies = companies
            self.tableView.reloadData()
        } catch let fetchError{
            print("Failed to fetch companies:", fetchError)
        }
    }
}

// MARK: - Helpers
extension CompagniesController {
    
    private func setup() {
        view.backgroundColor = .systemBackground
        title = "Société"
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Réinitialiser", style: .plain, target: self, action: #selector(reset))
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.tableFooterView = UIView()
    }
    
    private func layout() { }
}

// MARK: - DataSource and Delegate
extension CompagniesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
            view.backgroundColor = UIColor.lightBlue
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        cell.backgroundColor = UIColor.tealColor
        cell.tintColor = UIColor.lightRed
        
        let compagny = companies[indexPath.row]
      
        cell.textLabel?.text = compagny.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 16)
        
        return cell
    }
}

