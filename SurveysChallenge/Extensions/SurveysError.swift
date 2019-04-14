//
//  SurveysError.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/14/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

/// Create a custom error because API doesn't support the error message 'empty'
struct SurveysError: Error {
    let description: String
    
    var localizedDescription: String {
        return NSLocalizedString(description, comment: "")
    }
}
