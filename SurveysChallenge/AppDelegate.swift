//
//  AppDelegate.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        config()
        getLatestTokenIfNeeded()
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appCoordinator = AppCoordinator(window: window ?? UIWindow())
        appCoordinator.start()
        
        return true
    }
    
    private func getLatestTokenIfNeeded() {
        //TODO: Check the token expries everytime we make the new request if needed
        guard Utilities.getUserToken() != nil,
            let lastLoggedTime = Preferences.shared.lastLoggedTime,
            let tokenExpiresTime = Preferences.shared.tokenExpiresTime,
            Date().timeIntervalSince1970 <= lastLoggedTime.timeIntervalSince1970 + TimeInterval(tokenExpiresTime) else {
                UserTokenService.shared.fetch()
                return
        }
    }
}
