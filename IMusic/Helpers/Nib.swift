//
//  Nib.swift
//  IMusic
//
//  Created by Andrii Malyk on 29.08.2022.
//

import UIKit

extension UIView {
    //Беремо перший xib файл
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
