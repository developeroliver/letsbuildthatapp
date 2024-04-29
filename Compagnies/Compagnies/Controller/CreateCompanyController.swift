//
//  CreateCompanyController.swift
//  Compagnies
//
//  Created by olivier geiger on 28/04/2024.
//
import UIKit
import SnapKit
import CoreData

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    // MARK: - Properties
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
            guard let founded = company?.founded else { return }
            datePicker.date = founded
        }
    }
    
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
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "FR")
        return datePicker
    }()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationItem()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = company == nil ? "Créer une société" : "Éditer une société"
    }
}

// MARK: - @objc Functions
extension CreateCompanyController {
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleSave() {
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    
    @objc func saveCompanyChanges() {
        guard let name = nameTextField.text, !name.isEmpty else {
            let alertController = UIAlertController(title: "Champs incomplets", message: "Veuillez remplir tous les champs avant de sauvegarder.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        do {
            try context.save()
            dismiss(animated: true, completion: {
                self.delegate?.didEditCompany(company: self.company!)
            })
        } catch let saveError {
            print("Failed to save company:", saveError)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func createCompany() {
        guard let name = nameTextField.text, !name.isEmpty else {
            let alertController = UIAlertController(title: "Champs incomplets", message: "Veuillez remplir tous les champs avant de sauvegarder.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let saveError {
            print("Failed to save company:", saveError)
        }
    }
}

// MARK: - Helpers
extension CreateCompanyController {
    
    private func setup() {
        view.backgroundColor = UIColor.darkBlue
        
        
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
        view.addSubview(datePicker)
        
        lightBlueBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(lightBlueBackgroundView.snp.top).offset(10)
            make.leading.equalTo(lightBlueBackgroundView.snp.leading).offset(20)
            make.trailing.equalTo(lightBlueBackgroundView.snp.trailing).offset(-20)        }
        
        datePicker.snp.makeConstraints { make in
            make.leading.equalTo(lightBlueBackgroundView.snp.leading).offset(20)
            make.trailing.equalTo(lightBlueBackgroundView.snp.trailing).offset(-20)
            make.top.equalTo(stackView.snp.bottom).offset(8)
        }
    }
}

// MARK: - UITextFieldDelegate
extension CreateCompanyController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
