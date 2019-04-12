//
//  CoordinatorFactory.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit
import RxSwift

typealias CoordinatorPresentable = (coordinator: CoordinatorType, presentable: Presentable)

final class CoordinatorFactory {
    static func makeMainCoordinator() -> CoordinatorPresentable {
        let router = NavigationRouter(rootController: UINavigationController(rootViewController: MainSurveysViewController.instantiateFromStoryboard()))
        let coordinator = MainCoordinator(router: router)
        return (coordinator, router)
    }
    
    static func makeTakeSurveyCoordinator() -> CoordinatorPresentable {
        let router = NavigationRouter(rootController: UINavigationController(rootViewController: MakeSurveyViewController.instantiateFromStoryboard()))
        let coordinator = MakeSurveyCoordinator(router: router)
        return (coordinator, router)
    }
    
    static func makeErrorAlertCoordinator(title: String?, error: Error) -> CoordinatorType {
        return AlertCoordinator(title: title, error: error)
    }
}
