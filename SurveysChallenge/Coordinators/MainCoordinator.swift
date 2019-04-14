//
//  MainCoordinator.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator, CoordinatorErrorable {
    private let router: NavigationRouterType
    
    init(router: NavigationRouterType) {
        self.router = router
        super.init()
    }
    
    override func start() {
        let controller = MainSurveysViewController.instantiateFromStoryboard()
        
        let repository = SurveysListRepository(limitedPerPage: APIConst.pageLimit)
        let viewModelDependency = SurveysListViewModelDependency(repository: repository)
        let viewModel = MainSurveysViewModel(viewModelDependency)
        
        let dependency = SurveysListViewControllerDependency(viewModel: viewModel)

        controller.inject(dependency)
        controller.onErrorReceived = { [weak self] title, error in
            self?.openAlert(title: title, error: error)
        }

        controller.onSurveySelected = { [weak self] survey in
            self?.openTakeSurvey(survey)
        }
        
        router.setRootModule(controller, animated: false)
    }
}

private extension MainCoordinator {
    func openTakeSurvey(_ survey: Survey) {
        let controller = MakeSurveyViewController.instantiateFromStoryboard()
        controller.viewModel = MakeSurveyViewModel(survey)
        router.push(controller, animated: true, hideBottomBar: true)
    }
}
