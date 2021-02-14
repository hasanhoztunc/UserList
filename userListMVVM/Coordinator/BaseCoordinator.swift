//
//  BaseCoordinator.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

class BaseCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var isCompleted: (() -> ())?
    
    func start() {
        fatalError("Children should implement 'start'")
    }
}
