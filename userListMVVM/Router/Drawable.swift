//
//  Drawable.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 10.02.2021.
//

import UIKit

protocol Drawable {
    
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    
    var viewController: UIViewController? {
        return self
    }
}
