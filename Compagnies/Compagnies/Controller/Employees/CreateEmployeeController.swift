//
//  CreateEmployeeController.swift
//  Compagnies
//
//  Created by olivier geiger on 29/04/2024.
//

import UIKit
import SnapKit

class CreateEmployeeController: UIViewController {
    
    // MARK: - Properties
    let padding = 16
    
    // MARK: - UI Declarations
    lazy var lightBlueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nom"
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.backgroundColor = UIColor.lightBlue
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Entrer le nom"
        textField.font = UIFont(name: "AvenirNext-Medium", size: 18)
        textField.delegate = self
        return textField
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            nameTextField,
            UIView()
        ])
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationItem()
        layout()
    }
}

// MARK: - @objc Functions
extension CreateEmployeeController {
    
    @objc private func handeSave() {
        guard let employeeName = nameTextField.text else { return }
        let error = CoreDataManager.shared.createEmployee(employeeName: employeeName)
        
        if error != nil {
            let alert = UIAlertController(title: "Une erreur est survenue", message: "La sauvegarde a échouée.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            
        } else {
            dismiss(animated: true)
        }
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
}

// MARK: - Helpers
extension CreateEmployeeController {
    
    private func setup() {
        view.backgroundColor = UIColor.darkBlue
        title = "Créer un employé"
    }
    
    private func setupNavigationItem() {
        setupCancelButton(selector: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sauvegarder", style: .plain, target: self, action: #selector(handeSave))
    }
    
    private func layout() {
        view.addSubview(lightBlueBackgroundView)
        view.addSubview(stackView)
        
        lightBlueBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(lightBlueBackgroundView.snp.top).offset(padding)
            make.leading.equalTo(lightBlueBackgroundView.snp.leading).offset(padding)
            make.trailing.equalTo(lightBlueBackgroundView.snp.trailing).offset(-padding)
        }
    }
}

// MARK: - UITextFieldDelegate
extension CreateEmployeeController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
