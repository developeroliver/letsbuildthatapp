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
    
    func didEditCompany(company: Company) {
        let row = companies.firstIndex(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    // MARK: - Properties
    let reuseID = "CELL_ID"
    var companies = [Company]()
    var delegate: CreateCompanyControllerDelegate?
    
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
    
    @objc private func handleAddCompany() {
        let createCompanyController = CreateCompanyController()
        
        let navController = UINavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        
        present(navController, animated: true)
    }
    
    @objc private func handleReset() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
//        companies.forEach { company in
//            context.delete(company)
//        }
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            var indexPathToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .left)
           
        } catch let deleteError {
            print("Failed to delete objects from Core Data:", deleteError)
        }
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Réinitialiser", style: .plain, target: self, action: #selector(handleReset))
    }
    
    // MARK: - table view
    private func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(CompanyCell.self, forCellReuseIdentifier: reuseID)
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
        let view = CustomHeaderView()
        view.backgroundColor = UIColor.lightBlue
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! CompanyCell
        
        cell.backgroundColor = UIColor.tealColor
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.lightRed
        cell.selectedBackgroundView = selectedView
        let disclosureIndicator = UIImageView(image: UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate))
        disclosureIndicator.tintColor = .white
        cell.accessoryView = disclosureIndicator
        
        let company = companies[indexPath.row]
        cell.company = company
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Swipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") { [self] (action, view, completion) in
            let alertController = UIAlertController(title: "Supprimer", message: "Êtes-vous sûr de vouloir supprimer cette société ?", preferredStyle: .actionSheet)
            
            let confirmAction = UIAlertAction(title: "Confirmer", style: .destructive) { _ in
                let company = self.companies[indexPath.row]
                self.companies.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                
                let context = CoreDataManager.shared.persistentContainer.viewContext
                context.delete(company)
                
                do {
                    try context.save()
                } catch let saveError {
                    print("Failed to delete company:", saveError)
                }
                
                completion(true)
            }
            
            let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Éditer") { [self] (action, view, completion) in
            let editCompanyController = CreateCompanyController()
            
            editCompanyController.delegate = self
            editCompanyController.company = companies[indexPath.row]
            let navController = CustomNavigationController(rootViewController: editCompanyController)
            present(navController, animated: true, completion: nil)
            
            completion(true)
        }
        
        editAction.backgroundColor = UIColor.darkBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [ deleteAction, editAction])
        
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Pas de société de disponible..."
        label.textColor = .white
        label.textAlignment = .center
        label.font =  UIFont(name: "AvenirNext-Medium", size: 18)
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count ==  0 ? 150 : 0
    }
}

