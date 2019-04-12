//
//  SurveysAPI.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation
import Alamofire

/// Surveys API
///
/// - getListSurveys: use for fetching list of survey
/// - getNewToken: should separate to AuthAPI but there are only two requests so I'm gonna merge into one.
enum SurveysAPI {
    case getListSurveys(page: Int, pageLimit: Int)
    case getNewToken
}

extension SurveysAPI: APIEndpoint {
    var baseURLPath: String {
        return APIConst.BaseURLPath
    }
    
    var path: String {
        switch self {
        case .getListSurveys:
            return "/surveys.json"
        case .getNewToken:
            return "/oauth/token"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getListSurveys:
            return .get
        case .getNewToken:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getListSurveys:
            let userToken = Utilities.getUserToken() ?? ""
            return ["Authorization": "Bearer \(userToken)"]
        case .getNewToken:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
    
    var parameters: Parameters? {
        var params: Parameters = [:]
        switch self {
        case let .getListSurveys(page, pageLimit):
            params["page"] = page
            params["per_page"] = pageLimit
        case .getNewToken:
            params["grant_type"] = "password"
            params["username"] = APIConst.userName
            params["password"] = APIConst.password
        }
        return params
    }
    
    var parameterEncoding: ParameterEncoding? {
        return nil
    }
    
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        switch self {
        case .getListSurveys:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
        default:
            break
        }
        
        return decoder
    }
}
