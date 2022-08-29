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
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}

//Це наш кастомний barController
class MainTabBarController: UITabBarController {
    
    //Для повного екрану
    private var minimazedTopAnchorConstraint: NSLayoutConstraint!
    //Для скритого екрану
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAncorConstraint: NSLayoutConstraint!
    
    //Отримуємо детальний контроллер
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)

        setupTrackDetailView()
        searchVC.tabBarDelegate = self

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
        
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)

        // use auto layout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimazedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAncorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAncorConstraint.isActive = true
        maximizedTopAnchorConstraint.isActive = true
        
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}


extension MainTabBarController: MainTabBarControllerDelegate {
    
    //Метод презентує детальний контроллер - тут він просто виїжджає на верх
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        
        minimazedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        //Ставимо констрейнни на 0 щоб вони були на екрані а не за ним
        maximizedTopAnchorConstraint.constant = 0
        bottomAncorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            //Обновляємо екран дял того щоб було видко як скривається екран
            self.view.layoutIfNeeded()
            //Щоб tabBar як пропав з екрану
            self.tabBar.alpha = 0
            //Детальний контроллер показуємо а міні закриваємо
            self.trackDetailView.miniTrackView.alpha = 0
            self.trackDetailView.maximazedStackView.alpha = 1
        }
        
        guard let viewModel = viewModel else { return }

        //Сетимо данні по треку - заповнюємо UI елементи
        self.trackDetailView.set(viewModel: viewModel)
    }

    //Метод буде скривати анімовано додатковий екран з треком - екран як просто буде зїжджати в низ
    func minimizeTrackDetailController() {

        maximizedTopAnchorConstraint.isActive = false
        bottomAncorConstraint.constant = view.frame.height
        minimazedTopAnchorConstraint.isActive = true

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            //Обновляємо екран дял того щоб було видко як скривається екран
            self.view.layoutIfNeeded()
            //Тут вертаємо tabBar на місце, для того щоб він появився на екрані
            self.tabBar.alpha = 1
            //Детальний контроллер закриваємо а міні показуємо
            self.trackDetailView.miniTrackView.alpha = 1
            self.trackDetailView.maximazedStackView.alpha = 0
        }
    }
}

