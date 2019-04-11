//
//  UIButton+Extension.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit

extension UIButton {
    
    @IBInspectable var localizeKey: String {
        get {
            return ""
        } set {
            self.setTitle(NSLocalizedString(newValue, comment: ""), for: UIControl.State())
        }
    }
    
}
