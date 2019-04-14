//
//  TestSuite.swift
//  SurveysChallengeTests
//
//  Created by Canh Tran Wizeline on 4/14/19.
//  Copyright © 2019 Canh Tran. All rights reserved.
//

import Foundation
import SwiftyJSON

final class TestSuite {
    func json(fromResource resource: String) -> JSON {
        if let data = data(fromResource: resource, withExtension: "json") {
            do {
                return (try JSONSerialization.jsonObject(with: data, options: []) as? JSON) ?? [:]
            } catch {
                print(error.localizedDescription)
                return [:]
            }
        } else {
            return [:]
        }
    }
    
    func data(fromResource resource: String, withExtension extension: String) -> Data? {
        do {
            let bundle = Bundle(for: type(of: self))
            if let file = bundle.url(forResource: resource, withExtension: `extension`) {
                
                let data = try Data(contentsOf: file)
                return data
            } else {
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
