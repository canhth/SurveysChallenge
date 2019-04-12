//
//  Coordinator.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

class Coordinator: NSObject, CoordinatorType {
    private(set) var childCoordinators: [CoordinatorType] = []
    
    var finishCallback: ((CoordinatorType) -> Void)?
    
    override init() {
        super.init()
        logger?.verbose(typeName)
    }
    
    deinit {
        logger?.verbose(typeName)
    }
    
    func start() {
        assertionFailure("Function need to be overrided.")
    }
    
    func addDependency(_ coordinator: CoordinatorType) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: CoordinatorType) {
        guard !childCoordinators.isEmpty,
            childCoordinators.contains(where: { $0 === coordinator })
            else { return }
        
        // Clear child-coordinators recursively
        coordinator.removeAllDependencies()
        childCoordinators.removeAll(where: { $0 === coordinator })
    }
    
    func removeAllDependencies() {
        guard !childCoordinators.isEmpty else { return }
        childCoordinators.reversed().forEach({ removeDependency($0) })
    }
}
