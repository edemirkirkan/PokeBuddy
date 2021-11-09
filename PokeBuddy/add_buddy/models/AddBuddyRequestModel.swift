//
//  AddBuddyRequestModel.swift
//  PokeBuddy
//
//  Created by Deniz Turan Çağlarca on 13.09.2021.
//

import Foundation

class AddBuddyRequestModel {
    let buddyName: String
    let isNew: Bool
    let buddyStatus: String?
    
    init(buddyName: String, isNew: Bool, buddyStatus: String?){
        self.buddyName = buddyName
        self.isNew = isNew
        self.buddyStatus = buddyStatus
    }
    
    func createJsonObject() -> [String: Any] {
        if let buddyStatus = buddyStatus {
            let jsonObject: [String: Any] =
                [
                    "buddy_name": buddyName,
                    "is_new": isNew,
                    "buddy_status": buddyStatus,
                ]
            return jsonObject
        }
        let jsonObject: [String: Any] =
            [
                "buddy_name": buddyName,
                "is_new": isNew,
            ]
        return jsonObject
    }
}
