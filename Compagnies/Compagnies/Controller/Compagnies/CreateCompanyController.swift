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

class CreateCompanyController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    var company: Company? {
        didSet {
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            
            nameTextField.text = company?.name
            
            guard let founded = company?.founded else { return }
            datePicker.date = founded
        }
    }
    
    let padding = 16
    
    var delegate: CreateCompanyControllerDelegate?
    
    // MARK: - UI Declarations
    lazy var lightBlueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightBlue
        return view
    }()
    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "select_photo_empty")
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return imageView
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
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "FR")
        datePicker.preferredDatePickerStyle = .wheels
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
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleSave() {
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    
    @objc private  func saveCompanyChanges() {
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
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company?.imageData = imageData
        }
        
        do {
            try context.save()
            dismiss(animated: true, completion: {
                self.delegate?.didEditCompany(company: self.company!)
            })
        } catch let saveError {
            print("Failed to save company:", saveError)
        }
    }
    
    @objc private  func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - image picker
    @objc private func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true)
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
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 0.8)
            company.setValue(imageData, forKey: "imageData")
        }
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let saveError {
            print("Failed to save company:", saveError)
        }
    }
    
    private func setupCircularStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageView.layer.borderWidth = 2
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
        setupCancelButton(selector: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sauvegarder", style: .done, target: self, action: #selector(handleSave))
    }
    
    private func layout() {
        view.addSubview(lightBlueBackgroundView)
        view.addSubview(companyImageView)
        view.addSubview(stackView)
        view.addSubview(datePicker)
        
        lightBlueBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(350)
        }
        
        companyImageView.snp.makeConstraints { make in
            make.top.equalTo(lightBlueBackgroundView.snp.top).offset(8)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(companyImageView.snp.bottom).offset(padding)
            make.leading.equalTo(lightBlueBackgroundView.snp.leading).offset(padding)
            make.trailing.equalTo(lightBlueBackgroundView.snp.trailing).offset(-padding)    
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.equalTo(lightBlueBackgroundView.snp.leading).offset(padding)
            make.trailing.equalTo(lightBlueBackgroundView.snp.trailing).offset(-padding)
        }
        
        DispatchQueue.main.async {
                self.setupCircularStyle()
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

// MARK: - UIImagePickerControllerDelegate
extension CreateCompanyController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            companyImageView.image = editedImage
        } else {
            if let originalImage = info[.originalImage] as? UIImage {
                companyImageView.image = originalImage
            }
        }
        
        setupCircularStyle()
        
        picker.dismiss(animated: true, completion: nil)
    }
}
