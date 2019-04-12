//
//  MakeSurveyCoordinator.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

class MakeSurveyCoordinator: Coordinator, CoordinatorErrorable {
    private let router: NavigationRouterType
    
    init(router: NavigationRouterType) {
        self.router = router
        super.init()
    }
    
    override func start() {
        let controller = MakeSurveyViewController.instantiateFromStoryboard() 
        router.setRootModule(controller, animated: false)
    }
    
    private func finish(animated: Bool) {
        removeAllDependencies()
        router.dismissModule(animated: animated, completion: { [weak self] in
            guard let self = self else { return }
            self.finishCallback?(self)
        })
    }
}
