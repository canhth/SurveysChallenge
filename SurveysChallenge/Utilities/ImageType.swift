//
//  ImageService.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/13/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import UIKit
import Kingfisher

enum ImageType: String {
    case normal = ""
    case large = "l"
}

extension UIImageView {
    
    func combine(_ imagePath: String, kind: ImageType) -> URL? {
        return URL(string: imagePath + kind.rawValue)
    }
    
    func loadOrEmpty(_ path: String?, kind: ImageType, placeholder: UIImage? = nil) {
        let holderImage = placeholder ?? UIImage(named: "AdPlaceholder")
        
        guard let path = path else {
            image = holderImage
            return
        }
        
        let url = combine(path, kind: kind)
        kf.setImage(with: url, placeholder: holderImage)
    }
}
