//
//  CreateCompanyController.swift
//  Compagnies
//
//  Created by olivier geiger on 28/04/2024.
//
import UIKit
import SnapKit

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    // MARK: - Properties
    var delegate: CreateCompanyControllerDelegate?
    
    // MARK: - UI Declarations
    lazy var lightBlueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.backgroundColor = UIColor.lightBlue
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Entrer le nom"
        textField.font = UIFont(name: "AvenirNext-Medium", size: 14)
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
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
extension CreateCompanyController {
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleSave() {
        dismiss(animated: true) { [self] in
            guard let name = nameTextField.text else { return }
            let compagny = Company(name: name, founded: Date())
            
            delegate?.didAddCompany(company: compagny)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Helpers
extension CreateCompanyController {
    
    private func setup() {
        view.backgroundColor = UIColor.darkBlue
        title = "Créer une société"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sauvegarder", style: .done, target: self, action: #selector(handleSave))
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
            make.top.equalTo(lightBlueBackgroundView.snp.top).offset(5)
            make.leading.equalTo(lightBlueBackgroundView.snp.leading).offset(20)
            make.trailing.equalTo(lightBlueBackgroundView.snp.trailing).offset(-20)
            make.bottom.equalTo(lightBlueBackgroundView.snp.bottom).offset(-5)
        }
    }
}
