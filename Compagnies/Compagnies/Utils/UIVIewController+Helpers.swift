//
//  UIVIewController+Helpers.swift
//  Compagnies
//
//  Created by olivier geiger on 29/04/2024.
//

import UIKit

extension UIViewController {
    
    func setupPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton(selector: Selector) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Annuler", style: .plain, target: self, action: selector)
    }
}
