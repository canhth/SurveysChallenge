//
//  BaseViewController.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/13/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//
 
import UIKit

class BaseViewController: UIViewController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        logger?.verbose(typeName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        logger?.verbose(typeName)
    }
    
    deinit {
        logger?.verbose(typeName)
    }
}
