//
//  SurveysListTests.swift
//  SurveysChallengeTests
//
//  Created by Canh Tran Wizeline on 4/14/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
@testable import SurveysChallenge

final class SurveysListTests: BaseTests {
    
    // MARK: Properties
    var viewModel: MainSurveysViewModel!
    let disposeBag = DisposeBag()
    
    override func setUp() {
        // Initialize viewModel
        let repository = SurveysListRepository(limitedPerPage: APIConst.pageLimit)
        let viewModelDependency = SurveysListViewModelDependency(repository: repository)
        viewModel = MainSurveysViewModel(viewModelDependency)
    }
    
    /// Test parsing data to Objects <[Survey]>.
    func testParsingDataDecodable() throws {
        guard let data = TestSuite().data(fromResource: "surveysList", withExtension: "json") else {
            XCTFail("Can not get the data form surveysList.json")
            return
        }
        let surveysList = try JSONDecoder().decode([Survey].self, from: data)
        
        XCTAssertEqual(surveysList.count, 10)
    }
    
    /// Test API get list surveys by network
    func testFetchingListSurveysByNetwork() {
        let e = expectation(description: "test_surveys_by_network")
    
        viewModel.viewState.asObserver().subscribe(onNext: { state in
            switch state {
            case .error(let error):
                XCTFail(error.localizedDescription)
            case .working:
                e.fulfill()
            default: break
            }
        })
        .disposed(by: disposeBag)
        
        // Call this for start fetching data
        viewModel.refresh()
        
        waitForExpectations(timeout: limitTimeOut) { [unowned self] error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            } else {
                XCTAssertEqual(self.viewModel.surveys.count, 10)
            }
        }
    }
}
