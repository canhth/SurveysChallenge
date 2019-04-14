//
//  Notification.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/14/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

protocol SurveyNotification {
    var rawValue: String { get }
    func post(userInfo: [AnyHashable: Any])
}

extension SurveyNotification {
    
    var notificationName: String {
        return "\(type(of: self)).\(rawValue)"
    }
    
    /// Posts a Notification. NOT thread-safe.
    /// - Parameter userInfo: Optional dictionary for context with notification.
    func post(userInfo: [AnyHashable: Any] = [:]) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.notificationName), object: nil, userInfo: userInfo)
    }
    
    /// Configure the object to handle notifications
    /// - Parameters:
    ///     - observer: The object observing the notification
    ///     - selector: The method acting on the notification
    func observe(observer: Any, selector: Selector) {
        stopObserving(observer: observer)
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: notificationName), object: nil)
    }
    
    /// Stop the object from observing notifications.
    /// - Parameter observer: The object observing the notification.
    func stopObserving(observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: notificationName), object: nil)
    }
}
