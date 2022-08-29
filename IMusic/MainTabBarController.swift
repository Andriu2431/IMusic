//
//  MainTabBarController.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//

import UIKit
import SwiftUI

//Делегат через який буемо делегувати данними
protocol MainTabBarControllerDelegate: AnyObject {
    func minimizeTrackDetailController()
}

//Це наш кастомний barController
class MainTabBarController: UITabBarController {
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    //Для повного екрану
    private var minimazedTopAnchorConstraint: NSLayoutConstraint!
    //Для скритого екрану
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAncorConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)
        tabBar.backgroundColor = .white
        tabBar.alpha = 0.9

        setupTrackDetailView()

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

    //Тут будемо настроювати TrackDetailView
    private func setupTrackDetailView() {
        
        //Отримуємо детальний контроллер
        let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
        trackDetailView.backgroundColor = .green
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)

        // use auto layout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor)
        minimazedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAncorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAncorConstraint.isActive = true
        maximizedTopAnchorConstraint.isActive = true
        
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}


extension MainTabBarController: MainTabBarControllerDelegate {

    //Метод буде скривати анімовано додатковий екран з треком
    func minimizeTrackDetailController() {

        maximizedTopAnchorConstraint.isActive = false
        minimazedTopAnchorConstraint.isActive = true

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            //Обновляємо екран дял того щоб було видко як скривається екран
            self.view.layoutIfNeeded()
        }
    }
}

