//
//  CompagniesController.swift
//  Compagnies
//
//  Created by olivier geiger on 28/04/2024.
//

import UIKit
import CoreData

class CompagniesController: UITableViewController {
    
    // MARK: - Properties
    let reuseID = "CELL_ID"
    var companies = [Company]()
    var delegate: CreateCompanyControllerDelegate?
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.companies = CoreDataManager.shared.fetchCompanies()
        setup()
        setupNavigationItem()
        setupTableView()
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
        CoreDataManager.shared.resetCompanies {
            var indexPathToRemove = [IndexPath]()
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .left)
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
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Réinitialiser", style: .plain, target: self, action: #selector(handleReset))
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(CompanyCell.self, forCellReuseIdentifier: reuseID)
        tableView.tableFooterView = UIView()
    }
}

extension CompagniesController {
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
}
