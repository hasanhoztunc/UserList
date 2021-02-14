//
//  HttpRouter.swift
//  userListMVVM
//
//  Created by Hasan Oztunc on 8.02.2021.
//

import Alamofire

protocol HttpRouter {
    var baseUrlString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    func body() throws -> Data?

    func request(userHttpService service: HttpService) throws -> DataRequest
}

extension HttpRouter {
    var parameters: Parameters? { return nil }
    func body() throws -> Data? { return nil }
    var headers: HTTPHeaders? { return nil }
    
    func asUrlRequest() throws -> URLRequest {
        var url = try baseUrlString.asURL()
        url.appendPathComponent(path)
        
        var request = try URLRequest(url: url, method: method, headers: headers)
        request.httpBody = try body()
        
        return request
    }
    
    func request(userHttpService service: HttpService) throws -> DataRequest {
        return try service.request(asUrlRequest())
    }
}
