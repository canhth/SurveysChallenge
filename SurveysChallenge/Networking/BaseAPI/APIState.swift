//
//  APIState.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation 

/// Describle all the states of a request
///
/// - stoped: request has been stoped
/// - requesting: request is in progress
/// - response: request got response
/// - failed: request has failed
enum APIState {
    case stoped
    case requesting
    case response
    case failed(Error)
    
    var isStoped: Bool {
        switch self {
        case .stoped: return true
        default: return false
        }
    }
    
    var isRequesting: Bool {
        switch self {
        case .requesting: return true
        default: return false
        }
    }
    
    var hasResponse: Bool {
        switch self {
        case .response: return true
        default: return false
        }
    }
    
    var isFailed: Bool {
        switch self {
        case .failed: return true
        default: return false
        }
    }
}
