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
    var shortNameEmployees = [Employee]()
    var longNameEmployees = [Employee]()
    var reallyLongNameEmployees = [Employee]()
    var allEmployees = [[Employee]]()
    
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
        createEmployeeController.company = company
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
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        
        shortNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count < 6
            }
            return false
        })
        
        longNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count > 6 && count < 9
            }
            return false
        })
        
        reallyLongNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            if let count = employee.name?.count {
                return count > 9
            }
            return false
        })
        
        allEmployees = [
            shortNameEmployees,
            longNameEmployees,
            reallyLongNameEmployees
        ]
        
        print(shortNameEmployees.count, longNameEmployees.count, reallyLongNameEmployees.count)
    }
}

// MARK: - UITableView
extension EmployeesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        if let birthday = employee.employeeinformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            cell.textLabel?.text = "\(employee.name ?? "") - \(dateFormatter.string(from: birthday))"
        }
        
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 16)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        
        if section == 0 {
            label.text = "Développeur Junior"
        } else if section == 1 {
            label.text = "Développeur Intermédiaire"
        } else {
            label.text = "Développeur Sénior"
        }
        
        label.backgroundColor = UIColor.lightBlue
        label.textColor = UIColor.darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - Swipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") { [self] (action, view, completion) in
            let alertController = UIAlertController(title: "Supprimer", message: "Êtes-vous sûr de vouloir supprimer cet employé ?", preferredStyle: .actionSheet)
            
            let confirmAction = UIAlertAction(title: "Confirmer", style: .destructive) { [self] _ in
                let employee: Employee
                if indexPath.section == 0 {
                    employee = shortNameEmployees[indexPath.row]
                    shortNameEmployees.remove(at: indexPath.row)
                } else if indexPath.section == 1 {
                    employee = longNameEmployees[indexPath.row]
                    longNameEmployees.remove(at: indexPath.row)
                } else {
                    employee = reallyLongNameEmployees[indexPath.row]
                    reallyLongNameEmployees.remove(at: indexPath.row)
                }
                
                // Supprimer l'employé de toutes les structures de données associées
                employees.removeAll { $0 == employee }
                allEmployees[indexPath.section].remove(at: indexPath.row)
                
                // Supprimer l'employé de CoreData
                let context = CoreDataManager.shared.persistentContainer.viewContext
                context.delete(employee)
                
                do {
                    try context.save()
                } catch let saveError {
                    print("Failed to delete employee:", saveError)
                }
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                completion(true)
            }
            
            let cancelAction = UIAlertAction(title: "Annuler", style: .cancel) { _ in
                completion(true)
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

}
