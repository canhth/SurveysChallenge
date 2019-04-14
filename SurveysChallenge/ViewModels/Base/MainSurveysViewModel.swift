//
//  MainSurveysViewModel.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/13/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import RxSwift
import RxCocoa

typealias SurveysListViewModelDependency = MainSurveysViewModel.Dependency
extension MainSurveysViewModel {
    struct Dependency {
        let repository: SurveysListRepository
    }
}

final class MainSurveysViewModel {
    let viewState: BehaviorSubject<ViewState> = BehaviorSubject(value: .blank)
    let onRefresh: PublishSubject<Void> = PublishSubject()
    let onLoadMore: PublishSubject<Void> = PublishSubject()
    
    private(set) var surveys: [Survey] = []
    
    private let repository: SurveysListRepository
    private let disposeBag = DisposeBag()
    
    init(_ dependency: Dependency) {
        repository = dependency.repository
        
        onRefresh.subscribe(onNext: { [unowned self] _ in
            self.refresh()
        }).disposed(by: disposeBag)
        
        onLoadMore.subscribe(onNext: { [unowned self] _ in
            self.loadMore()
        }).disposed(by: disposeBag)
        
        repository.apiState.asObservable()
            .map({ ViewState($0) })
            .do(onNext: { [unowned self] viewState in
                guard viewState == .working else { return }
                self.surveys = self.repository.surveys
            })
            .bind(to: viewState)
            .disposed(by: disposeBag)
    }
    
    func refresh() {
        repository.refresh()
    }
    
    func loadMore() {
        repository.fetchNext()
    }
}
