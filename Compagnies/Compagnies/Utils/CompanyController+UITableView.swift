//
//  CompanyController+UITableView.swift
//  Compagnies
//
//  Created by olivier geiger on 29/04/2024.
//

import UIKit

extension CompagniesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CustomHeaderView()
        view.backgroundColor = UIColor.lightBlue
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // Cell
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let company = companies[indexPath.row]
        let navigation = EmployeesController()
        navigation.compagny = company
        
        navigationController?.pushViewController(navigation, animated: true)
    }
    
    // MARK: - Swipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") { [self] (action, view, completion) in
            let alertController = UIAlertController(title: "Supprimer", message: "Êtes-vous sûr de vouloir supprimer cette société ?", preferredStyle: .actionSheet)
            
            let confirmAction = UIAlertAction(title: "Confirmer", style: .destructive) { _ in
                let company = self.companies[indexPath.row]
                self.companies.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                
                let context = CoreDataManager.shared.persistentContainer.viewContext
                context.delete(company)
                
                do {
                    try context.save()
                } catch let saveError {
                    print("Failed to delete company:", saveError)
                }
                
                completion(true)
            }
            
            let cancelAction = UIAlertAction(title: "Annuler", style: .cancel) { _ in
                    completion(true)
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Éditer") { [self] (action, view, completion) in
            let editCompanyController = CreateCompanyController()
            
            editCompanyController.delegate = self
            editCompanyController.company = companies[indexPath.row]
            let navController = CustomNavigationController(rootViewController: editCompanyController)
            present(navController, animated: true, completion: nil)
            
            completion(true)
        }
        
        editAction.backgroundColor = UIColor.darkBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [ deleteAction, editAction])
        
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Pas de société de disponible..."
        label.textColor = .white
        label.textAlignment = .center
        label.font =  UIFont(name: "AvenirNext-Medium", size: 18)
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count ==  0 ? 150 : 0
    }
}
