//
//  NotificationsResponseModel.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 15.09.2021.
//

import Foundation
import SwiftyJSON

class NotificationsPostResponseModel {
    
    let success: Bool
    let msg: String
    
    init(json : JSON) {
        self.success = json["success"].boolValue
        self.msg = json["msg"].stringValue
    }
}
