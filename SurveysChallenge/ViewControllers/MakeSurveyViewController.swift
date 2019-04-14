//
//  MakeSurveyViewController.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/12/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit
import Kingfisher

final class MakeSurveyViewController: BaseViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: MakeSurveyViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        backgroundImageView.loadOrEmpty(viewModel.survey.coverImageURL, kind: .large)
        descriptionLabel.text = "You're making a survey about \(viewModel.survey.title), please complete \(viewModel.survey.questions.count) questions below:"
    }
}
