//
//  CompagniesController.swift
//  Compagnies
//
//  Created by olivier geiger on 28/04/2024.
//

import UIKit

class CompagniesController: UITableViewController {
    
    // MARK: - Properties
    let reuseID = "CELL_ID"
    let compagnies = [
        Company(name: "Apple", founded: Date()),
        Company(name: "Google", founded: Date()),
        Company(name: "Facebook", founded: Date()),
        Company(name: "Netflix", founded: Date()),
        Company(name: "Amazon", founded: Date()),
    ]
    
    // MARK: - UI
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBarItem()
        setupTableView()
        layout()
    }
}

// MARK: - @objc Functions
extension CompagniesController {
    
    @objc func handleAddCompany() {
       let createCompanyController = CreateCompanyController()
        
        let navController = UINavigationController(rootViewController: createCompanyController)
        present(navController, animated: true)
    }
    
    @objc func reset() {
        let alert = UIAlertController(title: "Réinitialisation data base", message: "Cette fonctionnalité n'est pas encore disponible.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Helpers
extension CompagniesController {
    
    private func setup() {
        view.backgroundColor = .systemBackground
        title = "Société"
    }
    
    private func setupNavigationBarItem() {
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
        return compagnies.count
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
        
        let compagny = compagnies[indexPath.row]
      
        cell.textLabel?.text = compagny.name
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 16)
        return cell
    }
}

