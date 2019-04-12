//
//  APIEndpoint.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

/// Base API endpoint applied for all the modules
protocol APIEndpoint: URLRequestConvertible {
    var baseURLPath: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameters: Parameters? { get }
    var parameterEncoding: ParameterEncoding? { get }
    var jsonDecoder: JSONDecoder { get }
    
    func responseEntity<T: Decodable>(_ type: T.Type) -> Observable<T>
    func responseEntities<T: Decodable>(_ type: [T.Type]) -> Observable<[T]>
}

extension APIEndpoint {
    var headers: HTTPHeaders {
        return ["Accept": "application/json"]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURLPath.asURL().appendingPathComponent(path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 10 * 1000
        
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        let encoding = parameterEncoding ?? URLEncoding.default
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    func responseEntity<T: Decodable>(_ type: T.Type) -> Observable<T> {
        return Alamofire.request(self)
            .validate()
            .rx.responseEntity(type, decoder: jsonDecoder)
    }

    func responseEntities<T: Decodable>(_ type: [T.Type]) -> Observable<[T]> {
        return Alamofire.request(self)
            .validate()
            .rx.responseEntities(type, decoder: jsonDecoder)
    }
}
