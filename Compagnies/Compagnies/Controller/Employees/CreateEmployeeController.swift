//
//  CreateEmployeeController.swift
//  Compagnies
//
//  Created by olivier geiger on 29/04/2024.
//

import UIKit
import SnapKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    // MARK: - Properties
    let padding = 16
    var delegate: CreateEmployeeControllerDelegate?
    var company: Company?
    let segmentedArray = ["Junior", "Intermédiaire", "Sénior"]
    
    
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
    
    lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            nameTextField,
            UIView()
        ])
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    
    lazy var birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Date de naissance"
        label.font = UIFont(name: "AvenirNext-Medium", size: 16)
        label.backgroundColor = UIColor.lightBlue
        return label
    }()
    
    lazy var birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "JJ/MM/AAAA"
        textField.font = UIFont(name: "AvenirNext-Medium", size: 18)
        textField.delegate = self
        return textField
    }()
    
    lazy var birthdayStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            birthdayLabel,
            birthdayTextField,
            UIView()
        ])
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var employeeTypeSegmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: segmentedArray)
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .lightBlue
        segment.selectedSegmentTintColor = UIColor.darkBlue
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segment.setTitleTextAttributes(titleTextAttributes, for:.normal)
        segment.layer.borderColor = UIColor.darkBlue.cgColor
        segment.layer.borderWidth = 1
        return segment
    }()
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationItem()
        layout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - @objc Functions
extension CreateEmployeeController {
    
    @objc private func handeSave() {
        guard let employeeName = nameTextField.text else { return }
        guard let company = self.company else { return }
        guard let birthdayText = birthdayTextField.text else { return }
        
        if employeeName.isEmpty {
            showAlert(title: "Le nom est vide.", message: "Veuillez entrer votre nom.")
            return
        }
        
        if birthdayText.isEmpty {
            showAlert(title: "Date d'anniversaire vide.", message: "Veuillez entrer votre date de naissance.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            showAlert(title: "Mauvaise date", message: "Veuillez vérifier si la date est correcte.")
            return
        }
        
        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else {
            return
        }
        
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, employeeType: employeeType, birthday: birthdayDate, company: company)
        
        if tuple.1 != nil {
            let alert = UIAlertController(title: "Une erreur est survenue", message: "La sauvegarde a échouée.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true) {
                self.delegate?.didAddEmployee(employee: tuple.0!)
            }
        }
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        return
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
        view.addSubview(nameStackView)
        view.addSubview(birthdayStackView)
        view.addSubview(employeeTypeSegmentedControl)
        
        lightBlueBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.top.equalTo(lightBlueBackgroundView.snp.top).offset(padding)
            make.leading.equalTo(lightBlueBackgroundView.snp.leading).offset(padding)
            make.trailing.equalTo(lightBlueBackgroundView.snp.trailing).offset(-padding)
        }
        
        birthdayStackView.snp.makeConstraints { make in
            make.top.equalTo(nameStackView.snp.bottom).offset(padding)
            make.leading.equalTo(lightBlueBackgroundView.snp.leading).offset(padding)
            make.trailing.equalTo(lightBlueBackgroundView.snp.trailing).offset(-padding)
        }
        
        employeeTypeSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(birthdayStackView.snp.bottom).offset(padding)
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

