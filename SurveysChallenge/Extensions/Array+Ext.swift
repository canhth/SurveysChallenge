//
//  Array+Ext.swift
//  SurveysChallenge
//
//  Created by Canh Tran Wizeline on 4/11/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation

extension Array {
    func get(at index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}
