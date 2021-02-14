//
//  UsersAPI.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

import RxSwift

protocol UsersAPI {
    func fetchUsers() -> Single<UsersResponse>
    func createUser(with model: UserModel) -> Single<Bool>
    func deleteUser(with model: UserModel) -> Single<Bool>
    func updateUser(with model: UserModel) -> Single<Bool>
}
