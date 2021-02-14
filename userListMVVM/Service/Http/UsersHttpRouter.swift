//
//  UsersHttpRouter.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

import Alamofire

enum UsersHttpRouter {
    case getUsers
    case createUser(user: UserModel)
    case updateUser(user: UserModel)
    case deleteUser(user: UserModel)
}

extension UsersHttpRouter: HttpRouter {

    var baseUrlString: String {
        return "http://127.0.0.1:3003/api/users"
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return ""
        case .createUser:
            return ""
        case .deleteUser:
            return ""
        case .updateUser:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        case .createUser:
            return .post
        case .updateUser:
            return .patch
        case .deleteUser:
            return .delete
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    func body() throws -> Data? {
        if case let .createUser(user) = self {
            return try user.jsonData()
        }
        else  if case let .updateUser(user) = self {
            return try user.jsonData()
        }
        else if case let .deleteUser(user) = self {
            return try user.jsonData()
        }
        else {
            return nil
        }
    }
}
