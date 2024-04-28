//
//  CompagniesViewController.swift
//  Compagnies
//
//  Created by olivier geiger on 28/04/2024.
//

import UIKit

import UIKit

class CompagniesViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Declarations
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBarItem()
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
    private func layout() {
        
    }
}

