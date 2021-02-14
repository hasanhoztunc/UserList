//
//  SuccessCoordinator.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 12.02.2021.
//
import RxSwift

final class SuccessCoordinator: BaseCoordinator {
    
    private let router: Routing
    
    private let bag = DisposeBag()
    
    init(router: Routing) {
        self.router = router
    }
    
    override func start() {
        let view = SuccessViewController.instantiate(from: "Success")
        
        view.viewModelBuilder = { [bag, router] in
            let viewModel = SuccessViewModel(input: $0)
            
            viewModel.routing.dismiss
                .map {
                    router.pop(true)
                }
                .drive()
                .disposed(by: bag)
            
            return viewModel
        }
        
        router.push(view, isAnimated: true, onNavigationBack: isCompleted)
    }
}
