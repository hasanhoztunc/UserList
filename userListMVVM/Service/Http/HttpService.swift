//
//  HttpService.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

import Alamofire

protocol HttpService {
    var sessionManager: Session { get }
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest
}
