//
//  SurveysListRepository.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation 
import RxSwift

/// Use for fetch all the surveys list
final class SurveysListRepository { 
    let apiState: Variable<APIState> = Variable(.stoped)

    private(set) var surveys: [Survey] = []

    private var totalPage: Int = .max
    private var currentPage: Int = 0
    private let limitedPerPage: Int

    private var request: Disposable?
    private let disposeBag = DisposeBag()

    init(limitedPerPage: Int) {
        self.limitedPerPage = limitedPerPage
    }
    
    deinit {
        print("SurveysList has been deinit!")
    }

    func refresh() {
        clear()
        fetch()
    }

    func fetchNext() {
        guard !apiState.value.isRequesting else { return }
        fetch()
    }
}

private extension SurveysListRepository {
    func clear() {
        currentPage = 0
        totalPage = .max
        surveys = []
        apiState.value = .stoped
        request?.dispose()
    }

    func fetch() {
        guard let api = makeAPI() else { return }

        request?.dispose()
        apiState.value = .requesting

        request = api
            .responseEntities([Survey.self])
            .subscribe(onNext: { [unowned self] result in
                self.bind(result)
                self.apiState.value = .response
                }, onError: { [unowned self] error in
                    self.apiState.value = .failed(error)
            })

        request?.disposed(by: disposeBag)
    }

    func bind(_ result: [Survey]) {
        surveys.append(contentsOf: result)
    }

    func makeAPI() -> SurveysAPI? {
        guard currentPage < totalPage else { return nil }

        let nextPage = currentPage + 1
        return .getListSurveys(page: nextPage, pageLimit: limitedPerPage)
    }
}
