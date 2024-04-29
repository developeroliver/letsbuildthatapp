//
//  EmployeesController.swift
//  Compagnies
//
//  Created by olivier geiger on 29/04/2024.
//

import UIKit
import SnapKit

class EmployeesController: UITableViewController {
    
    // MARK: - Properties
    var compagny: Company?
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = compagny?.name
    }
}

// MARK: - @objc Functions
extension EmployeesController {
    
    @objc private func handleAddEmployee() {
        let createCompanyController = CreateEmployeeController()
        
        let navController = UINavigationController(rootViewController: createCompanyController)
        
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
    }
}
