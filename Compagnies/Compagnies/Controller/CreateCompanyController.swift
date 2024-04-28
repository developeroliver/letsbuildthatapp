//
//  CreateCompanyController.swift
//  Compagnies
//
//  Created by olivier geiger on 28/04/2024.
//
import UIKit

class CreateCompanyController: UIViewController {
    
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
extension CreateCompanyController {
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
}

// MARK: - Helpers
extension CreateCompanyController {
    
    private func setup() {
        view.backgroundColor = UIColor.darkBlue
        title = "Créer une société"
    }
    
    private func setupNavigationBarItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCancel))
    }
    
    private func layout() {
        
    }
}
