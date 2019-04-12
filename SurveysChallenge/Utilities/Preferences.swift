//
//  Preferences.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

/// A class responsible for storing preferences specific to the application.
final class Preferences {
    
    /// Shared app's preferences
    static let shared = Preferences()
    
    /// Prevents users create an instance of `Preferences`
    /// `Preferences` should be accessed via `shared`
    private init() { }
    
    private let userDefaults: UserDefaults = .standard
    
    enum Preference: String {
        case lastLoggedTime
        case tokenExpiresTime
    }
    
    private func read(preference: Preference) -> Any? {
        return userDefaults.object(forKey: preference.rawValue)
    }
    
    private func write(value: Any, forPreference preference: Preference) {
        userDefaults.set(value, forKey: preference.rawValue)
    }
    
    private func remove(preference: Preference) {
        userDefaults.removeObject(forKey: preference.rawValue)
    }
    
    /// The flag to save the last time this user has authentication
    var lastLoggedTime: Date? {
        set {
            if let newValue = newValue {
                write(value: newValue, forPreference: .lastLoggedTime)
            }
        }
        get {
            return read(preference: .lastLoggedTime) as? Date
        }
    }
    
    /// The flag to save the living time of userToken
    var tokenExpiresTime: Int? {
        set {
            if let newValue = newValue {
                write(value: newValue, forPreference: .tokenExpiresTime)
            } else {
                remove(preference: .tokenExpiresTime)
            }
        }
        get {
            return read(preference: .tokenExpiresTime) as? Int
        }
    }
}
