//
//  Survey.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

struct Survey: Decodable {
    let id: String
    let title: String
    let description: String
    let isActive: Bool
    let coverImageURL: String
    let coverBackgroundColor: String?
    let type: String
    let questions: [Question]
    
    private enum CodingKeys: String, CodingKey {
        case id, title, description, type, questions
        case isActive = "is_active"
        case coverImageURL = "cover_image_url"
        case coverBackgroundColor = "cover_background_color"
    }
}
