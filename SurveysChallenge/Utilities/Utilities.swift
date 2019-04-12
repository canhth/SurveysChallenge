//
//  Utilities.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation
import KeychainAccess

final class Utilities {
    
    private static let keyChainService = "com.example.surveys-token"
    
    static func saveUserToken(tokenString: String) {
        let keychain = Keychain(service: keyChainService)
        keychain["userToken"] = tokenString
    }
    
    static func getUserToken() -> String? {
        let keychain = Keychain(service: keyChainService)
        guard let token = keychain["userToken"] else { return nil }
        return token
    }
}
