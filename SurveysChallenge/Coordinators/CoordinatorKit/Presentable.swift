//
//  Presentable.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit

protocol Presentable: AnyObject {
    func toPresent() -> UIViewController
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController {
        return self
    }
}
