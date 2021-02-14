//
//  Storyboarded.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

import UIKit

protocol Storyboardable {
    static func instantiate(from storyboard: String) -> Self
}

extension Storyboardable where Self: UIViewController {
    static func instantiate(from storyboard: String) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(identifier: className)
    }
}
