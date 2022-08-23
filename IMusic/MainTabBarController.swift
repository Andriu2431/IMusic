//
//  MainTabBarController.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//

import UIKit
import SwiftUI

//Це наш кастомний barController
class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)
        
        let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
        
        //Екран реалізований через SwiftUI
        let library = Library()
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = #imageLiteral(resourceName: "library")
        hostVC.tabBarItem.title = "Library"
        
        //Передаємо які контроллери ми хочемо бачити в tabBar
        viewControllers = [hostVC,
                           generateViewController(rootViewController: searchVC, image: #imageLiteral(resourceName: "search"), title: "Search")
        ]
    }
    
    //Метод який настроїть нам екрани
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        //Щоб Title був великим
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
}
