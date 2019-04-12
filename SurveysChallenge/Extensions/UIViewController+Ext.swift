//
//  UIViewController+Ext.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit

extension UIViewController {
    class func instantiateFromStoryboard(_ name: String = "Main") -> Self {
        return instantiateFromStoryboardHelper(name)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T: UIViewController>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return (storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? T) ?? T()
    }
}
