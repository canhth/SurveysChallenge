//
//  Constants.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//
 
import UIKit

enum APIConst {
    static let BaseURLPath = "https://nimble-survey-api.herokuapp.com"
    
    // Note: This is just a temporary for quick development
    static let userName = "carlos@nimbl3.com"
    static let password = "antikera"
    static let pageLimit = 10
}

enum LogConfig {
    static let DirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Logs", isDirectory: true) // swiftlint:disable:this force_unwrapping
    static let FileUrl = DirectoryUrl.appendingPathComponent("\(UIDevice.current.name)-\(Date()).log")
    static let SizesLimit = 1 * 1024 * 1024 // 1MB
    static let FilesLimit: Int = 50 // 50 files
}
