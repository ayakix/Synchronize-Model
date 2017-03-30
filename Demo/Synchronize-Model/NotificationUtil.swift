//
//  NotificationUtil.swift
//  Synchronize-Model
//
//  Created by r_ayaki on 2017/03/30.
//  Copyright © 2017年 Ayakix. All rights reserved.
//

import Foundation

class NotificationUtil {
    static func notifyModelChange(someModel: SomeModel, eventType: NotificationEventType) {
        let userInfo: [String: Any] = [
            NotificationInfoKey.model.rawValue: someModel,
            NotificationInfoKey.eventType.rawValue: eventType
        ]
        NotificationCenter.default.post(name: .changedModel, object: nil, userInfo: userInfo)
    }
}
