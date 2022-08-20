//
//  MainTabBarController.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//

import UIKit

//Це наш кастомний barController
class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)
        
        //Передаємо які контроллери ми хочемо бачити в tabBar
        viewControllers = [generateViewController(rootViewController: SearchMusicViewController(), image: #imageLiteral(resourceName: "search"), title: "Search"),
                           generateViewController(rootViewController: ViewController(), image: #imageLiteral(resourceName: "library"), title: "Library")
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
