//
//  AppDelegate+Config.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation
import Kingfisher
import XCGLogger

let logger: XCGLogger? = XCGLogger.customize()

extension AppDelegate {
    func config() {
        // Limit memory cache size to 300 MB
        ImageCache.default.diskStorage.config.sizeLimit = UInt(300 * 1024 * 1024)
        
        // Memory image expires after 10 minutes.
        ImageCache.default.memoryStorage.config.expiration = .seconds(600)
        
        // Disk image expiration about 1 day.
        ImageCache.default.diskStorage.config.expiration = .days(1)
    }
}
