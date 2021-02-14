//
//  Coordinator.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

protocol Coordinator: class {
    
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    
    func add(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func remove(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0 !== coordinator })
    }
}
