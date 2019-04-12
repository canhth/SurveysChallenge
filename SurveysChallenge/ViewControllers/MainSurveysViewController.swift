//
//  MainSurveysViewController.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit

protocol SurveyListViewType: ErrorActionable {
    var onSurveySelected: ((_ survey: Survey) -> Void)? { get set }
}

final class MainSurveysViewController: BaseViewController, SurveyListViewType {
    
    var onSurveySelected: ((Survey) -> Void)?
    
    var onErrorReceived: ((String?, Error) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
