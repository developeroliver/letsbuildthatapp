//
//  AppDelegate.swift
//  Compagnies
//
//  Created by olivier geiger on 28/04/2024.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let lightRed = UIColor(red: 247/255, green: 66/255, blue: 82/255, alpha: 1)
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().barTintColor = lightRed
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            UINavigationBar.appearance().tintColor = .white
            appearance.backgroundColor = lightRed
            appearance.largeTitleTextAttributes = [.foregroundColor : UIColor.white]
            appearance.titleTextAttributes = [.foregroundColor : UIColor.white]
            
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().standardAppearance = appearance
            
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        return true
    }
}

