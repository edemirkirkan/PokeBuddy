//
//  NotificationsResponseModel.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 15.09.2021.
//

import Foundation
import SwiftyJSON

class NotificationsResponseModel {
    
    let success: Bool
    let msg: String
    let notificationThirtyMinEnabled: Bool
    
    init(json : JSON) {
        self.success = json["success"].boolValue
        self.msg = json["msg"].stringValue
        self.notificationThirtyMinEnabled = json["notification_30_min"].boolValue
    }
}
