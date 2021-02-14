//
//  AddUserCoordinator.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 10.02.2021.
//

import UIKit
import RxSwift

final class AddUserCoordinator: BaseCoordinator {
    
    private let router: Routing
    private let model: UserModel?
    
    private let bag = DisposeBag()
    
    init(model: UserModel?, router: Routing) {
        self.router = router
        self.model = model
    }
    
    override func start() {
        let view = AddUserViewController.instantiate(from: "AddUser")
        
        let service = UsersService.shared
        
        view.viewModelBuilder = { [model, bag] in
            let viewModel = AddUserViewModel(
                input: $0,
                dependencies: (
                    title: "Kişiler",
                    model: model,
                    service: service
                )
            )
            
            viewModel.router.userCreatedUpdated
                .map({ [weak self] _ in
                    guard let self = self else { return }
                    self.showSuccess()
                })
                .drive()
                .disposed(by: bag)
            
            return viewModel
        }
        
        self.router.push(view, isAnimated: true, onNavigationBack: isCompleted)
    }
}

extension AddUserCoordinator {
    
    private func showSuccess() {
        let successCoordinator = SuccessCoordinator(router: router)
        self.add(coordinator: successCoordinator)
        
        successCoordinator.isCompleted = { [weak self, weak successCoordinator] in
            guard let coordinator = successCoordinator else { return }
            self?.remove(coordinator: coordinator)
        }
        
        successCoordinator.start()
    }
}
