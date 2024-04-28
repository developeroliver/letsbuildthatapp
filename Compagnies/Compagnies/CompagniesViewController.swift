//
//  CompagniesViewController.swift
//  Compagnies
//
//  Created by olivier geiger on 28/04/2024.
//

import UIKit

class CompagniesViewController: UITableViewController {
    
    // MARK: - Properties
    let reuseID = "CELL_ID"
    
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
extension CompagniesViewController {
    
    @objc func handleAddCompany() {
        let alert = UIAlertController(title: "Ajout d'une entrepise", message: "Cette fonctionnalité n'est pas encore disponible.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func reset() {
        let alert = UIAlertController(title: "Réinitialisation data base", message: "Cette fonctionnalité n'est pas encore disponible.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Helpers
extension CompagniesViewController {
    
    private func setup() {
        view.backgroundColor = .systemBackground
        title = "Compagnies"
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
extension CompagniesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
            view.backgroundColor = UIColor.lightBlue
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        
        cell.backgroundColor = UIColor.tealColor
      
        cell.textLabel?.text = "THE COMPAGNY NAME \([indexPath.row])"
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 16)
        return cell
    }
}

