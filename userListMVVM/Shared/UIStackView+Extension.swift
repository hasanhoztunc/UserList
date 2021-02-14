//
//  UIStackView+Extension.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 11.02.2021.
//

import UIKit

extension UIStackView {
    
    func removeArrangedSubview(_ view: UIView, shouldRemoveFromSuperView: Bool) {
        removeArrangedSubview(view)
        if shouldRemoveFromSuperView {
            view.removeFromSuperview()
        }
    }
}
