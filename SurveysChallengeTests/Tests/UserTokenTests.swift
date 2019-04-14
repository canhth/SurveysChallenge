//
//  UserTokenTests.swift
//  SurveysChallengeTests
//
//  Created by Canh Tran Wizeline on 4/14/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
@testable import SurveysChallenge

final class UserTokenTests: BaseTests {
    
    // MARK: Properties
    var userTokenService = UserTokenService()
    let disposeBag = DisposeBag()
    
    /// Test parsing data to Objects <[Survey]>.
    func testParsingTokenDataDecodable() throws {
        guard let data = TestSuite().data(fromResource: "userToken", withExtension: "json") else {
            XCTFail("Can not get the data form userToken")
            return
        }
        let userToken = try JSONDecoder().decode(UserToken.self, from: data)
        
        XCTAssertEqual(userToken.tokenType, "bearer")
        XCTAssertEqual(userToken.expiresIn, 7200)
    }
    
    /// Test API get list surveys by network
    func testGetUserTokenByNetwork() {
        let e = expectation(description: "test_get_userToken_by_network")
        
        userTokenService.apiState.asObservable().subscribe(onNext: { state in
            switch state {
            case .failed(let error):
                XCTFail(error.localizedDescription)
            case .response:
                e.fulfill()
            default: break
            }
        })
            .disposed(by: disposeBag)
        
        // Call this for start fetching data
        userTokenService.fetch()
        
        waitForExpectations(timeout: limitTimeOut) { [unowned self] error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            } else {
                if let userToken = self.userTokenService.userToken {
                    XCTAssertEqual(userToken.tokenType, "bearer")
                    XCTAssertEqual(userToken.expiresIn, 7200)
                } else {
                    XCTFail("Couldn't get the userToken")
                }
            }
        }
    }
}
