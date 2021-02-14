//
//  Routing.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 10.02.2021.
//

typealias NavigationBackClosure = (() -> ())

protocol Routing {
    
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigationBack: NavigationBackClosure?)
    func pop(_ isAnimated: Bool)
    func popToRoot(_ isAnimated: Bool)
    func present(_ drawable: Drawable, isAnimated: Bool, onDismiss: NavigationBackClosure?, isPopup: Bool)
}
