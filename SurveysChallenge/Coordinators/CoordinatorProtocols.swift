//
//  CoordinatorProtocols.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

protocol CoordinatorErrorable: CoordinatorType {
    func openAlert(title: String?, error: Error)
}

protocol ErrorActionable: Presentable {
    var onErrorReceived: ((_ title: String?, _ error: Error) -> Void)? { get set }
}

extension CoordinatorErrorable where Self: Coordinator {
    func openAlert(title: String?, error: Error) {
        guard !childCoordinators.contains(where: { $0 is AlertCoordinator }) else { return }
        
        let coordinator = CoordinatorFactory.makeErrorAlertCoordinator(title: title, error: error)
        
        coordinator.finishCallback = { [unowned self] caller in
            self.removeDependency(caller)
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
}
