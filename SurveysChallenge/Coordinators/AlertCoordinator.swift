//
//  AlertCoordinator.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit

final class AlertCoordinator: Coordinator {
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private let title: String?
    private let error: Error
    
    init(title: String?, error: Error) {
        self.title = title
        self.error = error
        super.init()
    }
    
    override func start() {
        let action = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            self?.finish(animated: true)
        }
        
        let message = (error as? SurveysError)?.localizedDescription ?? error.localizedDescription
        
        let alertController = UIAlertController(title: title ?? "Error",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(action)
        
        let rootController = UIViewController()
        window.windowLevel = .alert + 1
        window.rootViewController = rootController
        window.makeKeyAndVisible()
        
        rootController.present(alertController, animated: true)
    }
    
    private func finish(animated: Bool) {
        window.rootViewController?.dismiss(animated: animated)
        window.resignKey()
        finishCallback?(self)
    }
}
