//
//  NotificationsRequestModel.swift
//  PokeBuddy
//
//  Created by Ege Demirkirkan on 24.09.2021.
//

import Foundation

class NotificationsRequestModel {
    let notificationThirtyMinEnabled: Bool
    
    init(notificationThirtyMinEnabled: Bool) {
        self.notificationThirtyMinEnabled = notificationThirtyMinEnabled
    }
    
    func createJsonObject() -> [String: Any] {
        let jsonObject: [String: Any] =
        [
            "name": "notification_30_min",
            "value": notificationThirtyMinEnabled,
        ]
        return jsonObject
    }
}
