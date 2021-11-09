//
//  BuddyProfileModel.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 7.09.2021.
//

import Foundation
import SwiftyJSON

class BuddyProfileResponseModel {
    let success: Bool
    let msg: String
    let buddyName: String
    let buddyStatus: String
    let heartCount : Int
    let isNew: Bool
    let estimatedDays: Int

    init(json: JSON) {
        self.success = json["success"].boolValue
        self.msg = json["msg"].stringValue
        self.buddyName = json["buddy_name"].stringValue
        self.buddyStatus = json["buddy_status"].stringValue
        self.heartCount = json["heart_count"].intValue
        self.isNew = json["is_new"].boolValue
        self.estimatedDays = json["estimated_days"].intValue
    }
}
