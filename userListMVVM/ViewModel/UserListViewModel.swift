//
//  UserListViewModel.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

import RxSwift
import RxCocoa
import RxRelay
import RxDataSources

protocol UsersListViewPresentable {
    
    typealias Input = (
        searchText: Driver<String>,
        userSelect: Driver<UserViewModel>,
        userDelete: Driver<IndexPath>,
        userAdd: ControlEvent<()>
    )
    
    typealias Output = (
        users: Driver<[UserItemSection]>, ()
    )
    
    typealias ViewModelBuilder = (UsersListViewPresentable.Input) -> UsersListViewPresentable
    
    var input: UsersListViewPresentable.Input { get }
    var output: UsersListViewPresentable.Output { get }
}

final class UserListViewModel: UsersListViewPresentable {
    
    var input: UsersListViewPresentable.Input
    var output: UsersListViewPresentable.Output
    
    private let usersService: UsersAPI
    
    typealias State = (users: BehaviorRelay<Set<UserModel>>, ())
    private let state: State = (users: BehaviorRelay<Set<UserModel>>(value: []), ())
    
    typealias RoutingAction = (
        userSelectedRelay: PublishRelay<UserModel>,
        userAddRelay: PublishRelay<()>
    )
    private let routingAction: RoutingAction = (
        userSelectedRelay: PublishRelay(),
        userAddRelay: PublishRelay()
    )
    
    typealias Routing = (
        userSelected: Driver<UserModel>,
        addUser: Driver<()>
    )
    lazy var router: Routing = (
        userSelected: routingAction.userSelectedRelay.asDriver(onErrorDriveWith: .empty()),
        addUser: routingAction.userAddRelay.asDriver(onErrorDriveWith: .empty())
    )
    
    private let bag = DisposeBag()
    
    init(input: UsersListViewPresentable.Input, usersService: UsersAPI) {
        self.input = input
        self.output = UserListViewModel.output(input: self.input, state: self.state)
        self.usersService = usersService
        process()
    }
}

private extension UserListViewModel {
    static func output(input: UsersListViewPresentable.Input, state: State) -> UsersListViewPresentable.Output {
        let searchObservable = input.searchText
            .debounce(.milliseconds(300))
            .distinctUntilChanged()
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
        
        let usersObservable = state.users
            .asObservable()
        
        let sections = Observable.combineLatest(
            searchObservable,
            usersObservable
        )
        .map({ (seachKey, users) in
            return users.filter { (user) -> Bool in
                return user.userName
                    .lowercased()
                    .replacingOccurrences(of: " ", with: "")
                    .hasPrefix(seachKey.lowercased())
            }
        })
        .map({
            UserListViewModel.uniqueElements(from: $0.compactMap({
                UserViewModel(model: $0)
            }))
        })
        .map({
            [UserItemSection(model: 0, items: $0)]
        })
        .asDriver(onErrorJustReturn: [])
        
        return (users: sections, ())
    }
    
    func process() {
        self.usersService
            .fetchUsers()
            .map({ Set($0) })
            .map({ [state] in
                state.users.accept($0)
            })
            .subscribe()
            .disposed(by: bag)
        
        self.input.userAdd
            .map({ [routingAction] in
                routingAction.userAddRelay.accept(())
            })
            .asDriver(onErrorDriveWith: .empty())
            .drive()
            .disposed(by: bag)
        
        self.input.userSelect
            .withLatestFrom(state.users.asDriver()) { ($0, $1) }
            .map { (user, users) in
                users.filter({ $0.userEmail == user.userEmail }).first!
            }
            .debug("User", trimOutput: true)
            .map({ [routingAction] in
                routingAction.userSelectedRelay.accept($0)
            })
            .drive()
            .disposed(by: bag)
        
        self.input.userDelete
            .asObservable()
            .withLatestFrom(state.users.asObservable()) { ($0, $1) }
            .map({ (indexPath, users) -> UserModel? in
                let usersArray = Array(users)
                return users.filter({ $0.userId == usersArray[usersArray.endIndex - indexPath.row].userId }).first
            })
            .filter({ $0 != nil })
            .map({ $0! })
            .map({ [usersService, bag] model in
                usersService.deleteUser(with: model)
                    .subscribe()
                    .disposed(by: bag)
            })
            .asDriver(onErrorDriveWith: .empty())
            .drive()
            .disposed(by: bag)
    }
}

private extension UserListViewModel {
    
    static func uniqueElements(from array: [UserViewModel]) -> [UserViewModel] {
        var set = Set<UserViewModel>()
        let result = array.filter({
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        })
        
        return result
    }
}
