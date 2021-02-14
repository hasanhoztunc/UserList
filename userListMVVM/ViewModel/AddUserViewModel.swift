//
//  AddUserViewModel.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 10.02.2021.
//

import RxSwift
import RxCocoa

protocol AddUserViewPresentable {
    
    typealias Input = (
        userName: Driver<String>,
        userLastName: Driver<String>,
        userDateOfBirth: Driver<String>,
        userEmail: Driver<String>,
        userPhone: Driver<String>,
        userNote: Driver<String>,
        saveUser: ControlEvent<()>
    )
    typealias Output = (
        title: Driver<String>,
        user: Driver<UserModel?>
    )
    typealias Dependencies = (
        title: String,
        model: UserModel?,
        service: UsersAPI
    )
    typealias ViewModelBuilder = (AddUserViewPresentable.Input) -> AddUserViewPresentable
    
    var input: Input { get }
    var output: Output { get }
}

final class AddUserViewModel: AddUserViewPresentable {
    
    var input: AddUserViewPresentable.Input
    var output: AddUserViewPresentable.Output
    
    typealias RoutingAction = (userCreatedUpdatedRelay: PublishRelay<UserModel>, ())
    private let routingAction: RoutingAction = (userCreatedUpdatedRelay: PublishRelay(), ())
    
    typealias Routing = (userCreatedUpdated: Driver<UserModel>, ())
    lazy var router: Routing = (
        userCreatedUpdated: routingAction.userCreatedUpdatedRelay
            .asDriver(onErrorDriveWith: .empty()),
        ()
    )
    
    private let bag = DisposeBag()
    
    init(input: AddUserViewPresentable.Input,
         dependencies: AddUserViewPresentable.Dependencies) {
        self.input = input
        self.output = AddUserViewModel.output(dependencies: dependencies)
        self.process(dependencies: dependencies)
    }
}

private extension AddUserViewModel {
    
    static func output(dependencies: AddUserViewPresentable.Dependencies) -> AddUserViewPresentable.Output {
        let user = Driver.just(dependencies.model)
        
        return (
            title: Driver.just(dependencies.title),
            user: user
        )
    }
    
    func process(dependencies: AddUserViewPresentable.Dependencies) {
        let userData = Driver.combineLatest(self.input.userName,
                                            self.input.userLastName,
                                            self.input.userDateOfBirth,
                                            self.input.userEmail,
                                            self.input.userPhone,
                                            self.input.userNote)
            .map({ (userName, userLastName, userDateOfBirth, userEmail, userPhone, userNote) -> UserModel in
                let userId = dependencies.model == nil ? 0 : dependencies.model!.userId
                return UserModel(userId: userId,
                          userName: userName,
                          userLastName: userLastName,
                          userDateOfBirth: userDateOfBirth,
                          userEmail: userEmail,
                          userPhone: userPhone,
                          userNote: userNote)
            })
            
        self.input.saveUser
            .asDriver()
            .withLatestFrom(userData)
            .map({ [routingAction, bag] in
                if dependencies.model == nil {
                    dependencies.service
                        .createUser(with: $0)
                        .subscribe()
                        .disposed(by: bag)
                    
                } else {
                    dependencies.service
                        .updateUser(with: $0)
                        .subscribe()
                        .disposed(by: bag)
                }
                
                routingAction.userCreatedUpdatedRelay.accept($0)
            })
            .drive()
            .disposed(by: bag)
    }
}
