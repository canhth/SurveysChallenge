//
//  CustomPageControl.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/14/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit

final class CustomPageControl: UIPageControl {
    
    var customBorderColor: UIColor = .clear
    
    override var currentPage: Int {
        didSet {
            updateBorderColor()
        }
    }
    
    private func updateBorderColor() {
        subviews.enumerated().forEach { index, subview in
            if index != currentPage {
                subview.layer.borderColor = customBorderColor.cgColor
                subview.layer.borderWidth = 0.5
            } else {
                subview.layer.borderWidth = 0
            }
        }
    }
    
}
