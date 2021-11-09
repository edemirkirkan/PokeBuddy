//
//  AddBuddyResponseModel.swift
//  PokeBuddy
//
//  Created by Deniz Turan Çağlarca on 13.09.2021.
//

import Foundation
import SwiftyJSON

class AddBuddyResponseModel {
    let success: Bool
    let msg: String
    
    init(json: JSON){
        self.success = json["success"].boolValue
        self.msg = json["msg"].stringValue
    }
}
