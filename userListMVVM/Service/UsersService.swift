//
//  UsersService.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

import RxSwift
import Alamofire

final class UsersService {
    
    private lazy var httpService: UsersHttpService = UsersHttpService()
    
    private init() { }
    
    static let shared: UsersService = UsersService()
}

extension UsersService: UsersAPI {
    
    func fetchUsers() -> Single<UsersResponse> {
        return Single.create { [httpService] single -> Disposable in
            do {
                try UsersHttpRouter.getUsers
                    .request(userHttpService: httpService)
                    .responseJSON { (result) in
                        do {
                            let users = try UsersService.parseUsers(result: result)
                            single(.success(users))
                        } catch {
                            single(.failure(error))
                        }
                    }
            } catch {
                single(.failure(CustomError.error(message: "Users fetch failed")))
            }
            return Disposables.create()
        }
    }
    
    func createUser(with model: UserModel) -> Single<Bool> {
        return Single.create { [httpService] single -> Disposable in
            do {
                try UsersHttpRouter.createUser(user: model)
                    .request(userHttpService: httpService)
                    .responseJSON(completionHandler: { (result) in
                        do {
                            try UsersService.parseResponse(result: result)
                            single(.success(true))
                        } catch {
                            single(.failure(CustomError.error(message: "Response fetch failed")))
                        }
                    })
            } catch {
                single(.failure(CustomError.error(message: "Create user failed")))
            }
            return Disposables.create()
        }
    }
    
    func updateUser(with model: UserModel) -> Single<Bool> {
        return Single.create { [httpService] single -> Disposable in
            do {
                try UsersHttpRouter.updateUser(user: model)
                    .request(userHttpService: httpService)
                    .responseJSON(completionHandler: { (result) in
                        do {
                            try UsersService.parseResponse(result: result)
                            single(.success(true))
                        } catch {
                            single(.failure(CustomError.error(message: "Response fetch failed")))
                        }
                    })
            } catch {
                single(.failure(CustomError.error(message: "User update failed")))
            }
            
            return Disposables.create()
        }
    }
    
    func deleteUser(with model: UserModel) -> Single<Bool> {
        return Single.create { [httpService] single -> Disposable in
            do {
                try UsersHttpRouter.deleteUser(user: model)
                    .request(userHttpService: httpService)
                    .responseJSON(completionHandler: { (result) in
                        do {
                            try UsersService.parseResponse(result: result)
                            single(.success(true))
                        } catch {
                            single(.failure(CustomError.error(message: "Response fetch failed")))
                        }
                    })
            } catch {
                single(.failure(CustomError.error(message: "User delete failed")))
            }
            
            return Disposables.create()
        }
    }
}

extension UsersService {
    
    static func parseUsers(result: AFDataResponse<Any>) throws -> UsersResponse {
        guard let data = result.data,
              let usersResponse = try? JSONDecoder().decode(UsersResponse.self, from: data)
        else { throw CustomError.error(message: "Invalid Users JSON")}
        
        return usersResponse
    }
    
    @discardableResult
    static func parseResponse(result: AFDataResponse<Any>) throws -> UserServerResponse {
        guard let data = result.data,
              let serverResponse = try? JSONDecoder().decode(UserServerResponse.self, from: data)
        else { throw CustomError.error(message: "Invalid user server response") }
        
        return serverResponse
    }
}
