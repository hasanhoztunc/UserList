//
//  UserListCoordinator.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

import UIKit
import RxSwift

final class UserListCoordinator: BaseCoordinator {
    
    var router: Routing
    
    private let bag = DisposeBag()
    
    init(router: Routing) {
        self.router = router
    }
    
    override func start() {
        let view = UserListViewController.instantiate(from: "UserList")
        
        let service = UsersService.shared
        
        view.viewModelBuilder = { [bag] in
            let viewModel = UserListViewModel(input: $0, usersService: service)
            
            viewModel.router.userSelected
                .map { [weak self] in
                    guard let self = self else { return }
                    self.showUser(usingModel: $0)
                }
                .drive()
                .disposed(by: bag)
            
            viewModel.router.addUser
                .map { [weak self] in
                    guard let self = self else { return }
                    self.showUser(usingModel: nil)
                }
                .drive()
                .disposed(by: bag)
            
            return viewModel
        }
        
        router.push(view, isAnimated: true, onNavigationBack: isCompleted)
    }
}

private extension UserListCoordinator {
    
    private func showUser(usingModel model: UserModel?) {
        
        let addUserCoordinator = AddUserCoordinator(model: model, router: router)
        add(coordinator: addUserCoordinator)
        
        addUserCoordinator.isCompleted = { [weak self, weak addUserCoordinator] in
            guard let coordinator = addUserCoordinator else { return }
            self?.remove(coordinator: coordinator)
        }
        
        addUserCoordinator.start()
    }
}
