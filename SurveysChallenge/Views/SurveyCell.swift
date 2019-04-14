//
//  SurveyCell.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/13/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit
import Kingfisher

final class SurveyCell: UITableViewCell, ViewSuspendable {
    
    // MARK: IBOutlets & variables
    @IBOutlet weak private var backgroundImageView: UIImageView!
    @IBOutlet weak private var backgroundColorView: UIView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var takeSurveyButton: UIButton!
    
    var onSurveySelected: (() -> Void)?
    
    func setupCellWithData(survey: Survey) {
        nameLabel.text = survey.title
        descriptionLabel.text = survey.description
        if let backgroundColorString = survey.coverBackgroundColor {
            backgroundColorView.backgroundColor = UIColor(hex: backgroundColorString)
        }
        backgroundImageView.loadOrEmpty(survey.coverImageURL, kind: .large)
    }
    
    @IBAction private func takeSurveyButtonTapped(_ sender: Any) {
        self.onSurveySelected?()
    }
    
    func suspend() {
        imageView?.kf.cancelDownloadTask()
    }
}
