//
//  EmployeesController.swift
//  Compagnies
//
//  Created by olivier geiger on 29/04/2024.
//

import UIKit
import SnapKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    // MARK: - Protocol
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    // MARK: - Properties
    var company: Company?
    var employees = [Employee]()
    let reuseID = "CELL_ID"
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = company?.name
        fetchEmployee()
    }
}

// MARK: - @objc Functions
extension EmployeesController {
    
    @objc private func handleAddEmployee() {
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        
        let navController = UINavigationController(rootViewController: createEmployeeController)
        
        present(navController, animated: true)
    }
}

// MARK: - Helpers
extension EmployeesController {
    
    private func setupNavigationItem() {
        setupPlusButtonInNavBar(selector: #selector(handleAddEmployee))
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.tableFooterView = UIView()
    }
    
    private func fetchEmployee() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let request = NSFetchRequest<Employee>(entityName: "Employee")
        
        do {
            let employees = try context.fetch(request)
            self.employees = employees
        } catch let fetchError {
            print("Failed to fecth employee:", fetchError)
        }
    }
}

extension EmployeesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        let employee = employees[indexPath.row]
        
        if let taxId = employee.employeeinformation?.taxId {
            cell.textLabel?.text = "\(employee.name ?? "") - \(taxId)"
        }
        
        cell.backgroundColor = UIColor.tealColor
//        cell.textLabel?.text = employee.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 16)
        
        return cell
    }
    
    // MARK: - Swipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") { [self] (action, view, completion) in
            let alertController = UIAlertController(title: "Supprimer", message: "Êtes-vous sûr de vouloir supprimer cet employé ?", preferredStyle: .actionSheet)
            
            let confirmAction = UIAlertAction(title: "Confirmer", style: .destructive) { _ in
                let employee = self.employees[indexPath.row]
                self.employees.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                
                let context = CoreDataManager.shared.persistentContainer.viewContext
                context.delete(employee)
                
                do {
                    try context.save()
                } catch let saveError {
                    print("Failed to delete employee:", saveError)
                }
                
                completion(true)
            }
            
            let cancelAction = UIAlertAction(title: "Annuler", style: .cancel) { _ in
                completion(true)
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [ deleteAction])
        
        return configuration
    }
}
