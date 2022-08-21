//
//  UIViewController + Storyboard.swift
//  IMusic
//
//  Created by Andriy on 20.08.2022.
//

import UIKit

extension UIViewController {
    
    //Метод буде шукати файл типу UIStoryboard - тобто якщо є 2 однакових імені то ми шукаємо типу UIStoryboard
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("Error no initial view controller in \(name) storyboard")
        }
    }
}
