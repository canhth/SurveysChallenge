//
//  UserTokenService.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation
import RxSwift

enum AuthNotification: String, SurveyNotification {
    
    /// Informs when the user did log in
    case logIn
    
    /// Informs when the user did log out
    case logOut
}

/// Use for fetching the latest token
final class UserTokenService {
    
    static let shared = UserTokenService()
    
    let apiState: Variable<APIState> = Variable(.stoped)
    
    private var request: Disposable?
    private(set) var userToken: UserToken?
    private let disposeBag = DisposeBag()
    
    func fetch() {
        request?.dispose()
        apiState.value = .requesting
        
        request = SurveysAPI.getNewToken
            .responseEntity(UserToken.self)
            .subscribe(onNext: { [unowned self] result in
                self.apiState.value = .response
                self.userToken = result
                
                // Save user information
                Utilities.saveUserToken(tokenString: result.accessToken)
                Preferences.shared.tokenExpiresTime = result.expiresIn
                Preferences.shared.lastLoggedTime = Date(timeIntervalSince1970: TimeInterval(result.createdAt))
                
                // Post notification user did login
                AuthNotification.logIn.post()
                
                }, onError: { [unowned self] error in
                    self.apiState.value = .failed(error)
            })
        
        request?.disposed(by: disposeBag)
    }
}
