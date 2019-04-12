//
//  Router.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit

protocol RouterType: Presentable {
    func isPresentable() -> Bool
    func present(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
}

extension RouterType {
    func present(_ module: Presentable, animated: Bool, completion: (() -> Void)? = nil) {
        present(module, animated: animated, completion: completion)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)? = nil) {
        dismissModule(animated: animated, completion: completion)
    }
}

class Router: NSObject, RouterType {
    private let rootController: UIViewController
    
    init(rootController: UIViewController) {
        self.rootController = rootController
        super.init()
        logger?.verbose(typeName)
    }
    
    deinit {
        logger?.verbose(typeName)
    }
    
    func toPresent() -> UIViewController {
        return rootController
    }
    
    // MARK: - Present & Dismiss
    
    func isPresentable() -> Bool {
        return rootController.presentedViewController != nil
    }
    
    func present(_ module: Presentable, animated: Bool, completion: (() -> Void)?) {
        guard validateOnPresent(module.toPresent()) else { return }
        rootController.present(module.toPresent(), animated: animated, completion: completion)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController.dismiss(animated: animated, completion: completion)
    }
}

private extension Router {
    func validateOnPresent(_ controller: UIViewController) -> Bool {
        switch (controller.presentingViewController, rootController.presentedViewController) {
        case (.some, _):
            logger?.warning(controller)
            assertionFailure("`controller` is being presented by another parent already.")
            return false
        case (_, .some):
            logger?.warning(rootController)
            assertionFailure("`rootController` is presenting another child.")
            return false
        default:
            return true
        }
    }
}
