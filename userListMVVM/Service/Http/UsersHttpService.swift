//
//  UsersHttpService.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

import Alamofire

final class UsersHttpService: HttpService {
    
    var sessionManager: Session = Session.default
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return sessionManager.request(urlRequest).validate(statusCode: 200..<400)
    }
}
