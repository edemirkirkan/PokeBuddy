//
//  LoginModel.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 6.09.2021.
//

import Foundation
import SwiftyJSON

class LoginResponseModel {
    
    let success: Bool
    let msg: String
    let authToken : String
    
    init(json : JSON) {
        self.success = json["success"].boolValue
        self.msg = json["msg"].stringValue
        self.authToken = json["auth_token"].stringValue
    }
}
