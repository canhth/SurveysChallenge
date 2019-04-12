//
//  AppCoordinator.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit 

final class AppCoordinator: Coordinator, CoordinatorErrorable {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    override func start() {
        let (coordinator, presentable) = CoordinatorFactory.makeMainCoordinator()
        
        coordinator.finishCallback = { [unowned self] caller in
            self.removeDependency(caller)
        }
        
        window.rootViewController = presentable.toPresent()
        window.makeKeyAndVisible()
        
        addDependency(coordinator)
        coordinator.start()
    }
}

private extension AppCoordinator {
    func printOut() {
        logger?.info(structure(coordinator: self, level: 1))
    }
    
    private func structure(coordinator: Coordinator, level: Int) -> String {
        let prefix = stride(from: 0, to: level, by: 1).map({ _ in "    " }).joined()
        var str = "\n\(prefix)\(level).\(coordinator)"
        
        for c in coordinator.childCoordinators {
            if let childCoordinator = c as? Coordinator {
                str += structure(coordinator: childCoordinator, level: level + 1)
            }
        }
        return str
    }
}
