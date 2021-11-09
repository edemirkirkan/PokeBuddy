//
//  LoginRequestModel.swift
//  PokeBuddy
//
//  Created by Bilge Eren on 8.09.2021.
//

import Foundation
 
class LoginRequestModel {
    let idToken: String
    
    init(idToken: String) {
        self.idToken = idToken
    }
    
    func createJsonObject() -> [String: Any] {
        let jsonObject: [String: Any] =
        [
            "idToken": idToken,
        ]
        return jsonObject
    }
    
}
