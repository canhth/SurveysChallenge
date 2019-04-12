//
//  CoordinatorType.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

protocol CoordinatorType: AnyObject {
    var childCoordinators: [CoordinatorType] { get }
    var finishCallback: ((CoordinatorType) -> Void)? { get set }
    
    func start() 
    func addDependency(_ coordinator: CoordinatorType)
    func removeDependency(_ coordinator: CoordinatorType)
    func removeAllDependencies()
}
