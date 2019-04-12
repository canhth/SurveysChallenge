//
//  NavigationRouter.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit

protocol NavigationRouterType: RouterType {
    func toPresent() -> UINavigationController
    
    func push(_ module: Presentable, animated: Bool, hideBottomBar: Bool?, popCompletion: (() -> Void)?)
    func popModule(animated: Bool)
    func popThroughModule(_ module: Presentable, animated: Bool)
    
    func setRootModule(_ module: Presentable, animated: Bool, hideNavigationBar: Bool?)
    func popToRootModule(animated: Bool)
}

extension NavigationRouterType {
    func push(_ module: Presentable, animated: Bool, hideBottomBar: Bool? = nil, popCompletion: (() -> Void)? = nil) {
        push(module, animated: animated, hideBottomBar: hideBottomBar, popCompletion: popCompletion)
    }
    
    func setRootModule(_ module: Presentable, animated: Bool, hideNavigationBar: Bool? = nil) {
        setRootModule(module, animated: animated, hideNavigationBar: hideNavigationBar)
    }
}

final class NavigationRouter: Router, NavigationRouterType {
    private let rootController: UINavigationController
    private var popCompletions: [UIViewController: () -> Void] = [:]
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
        super.init(rootController: rootController)
        rootController.delegate = self
    }
    
    override func toPresent() -> UINavigationController {
        return rootController
    }
    
    // MARK: - Push & Pop
    
    func push(_ module: Presentable, animated: Bool, hideBottomBar: Bool?, popCompletion: (() -> Void)?) {
        guard validateOnPush(module.toPresent()) else { return }
        
        let newController = module.toPresent()
        if let hideBottomBar = hideBottomBar {
            newController.hidesBottomBarWhenPushed = hideBottomBar
        }
        
        rootController.pushViewController(newController, animated: animated)
        popCompletions[newController] = popCompletion
    }
    
    func popModule(animated: Bool) {
        if let controller = rootController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func popThroughModule(_ module: Presentable, animated: Bool) {
        if let controllers = rootController.popThroughViewController(module.toPresent(), animated: animated) {
            controllers.reversed().forEach({ runCompletion(for: $0) })
        }
    }
    
    func popToRootModule(animated: Bool) {
        if let controllers = rootController.popToRootViewController(animated: animated) {
            controllers.reversed().forEach({ runCompletion(for: $0) })
        }
    }
    
    // MARK: - Root Module
    
    func setRootModule(_ module: Presentable, animated: Bool, hideNavigationBar: Bool?) {
        guard validateOnPush(module.toPresent()) else { return }
        
        let newController = module.toPresent()
        let oldControllers = rootController.viewControllers
        
        rootController.setViewControllers([newController], animated: animated)
        if let hideNavigationBar = hideNavigationBar {
            rootController.isNavigationBarHidden = hideNavigationBar
        }
        
        oldControllers.reversed().forEach({ runCompletion(for: $0) })
    }
}

// MARK: - Extensions

private extension NavigationRouter {
    func runCompletion(for controller: UIViewController) {
        guard let completion = popCompletions[controller] else { return }
        popCompletions.removeValue(forKey: controller)
        completion()
    }
    
    func validateOnPush(_ controller: UIViewController) -> Bool {
        switch controller {
        case is UINavigationController:
            logger?.warning(controller)
            assertionFailure("pushed `controller` is UINavigationController.")
            return false
        default:
            return true
        }
    }
}

extension NavigationRouter: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard
            let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController)
            else { return }
        runCompletion(for: poppedViewController)
    }
}

private extension UINavigationController {
    /// Pops view controllers until the one specified is on top. Returns the popped controllers.
    ///
    /// - Parameters:
    ///   - viewController: controller which is popped through
    ///   - animated: animate or not
    /// - Returns: array of controllers (contain specified controller)
    func popThroughViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        guard
            let index = viewControllers.firstIndex(of: viewController),
            let preViewController = viewControllers.get(at: index - 1)
            else { return nil }
        
        return popToViewController(preViewController, animated: animated)
    }
}
