//
//  Constants.swift
//  Synchronize-Model
//
//  Created by Ayakix on 2017/03/29.
//  Copyright © 2017年 Ayakix. All rights reserved.
//

import Foundation

enum NotificationInfoKey: String {
    case model
    case eventType
}

enum NotificationEventType: Int {
    case update
    case delete
}

extension NSNotification.Name {
    static let changedModel = Notification.Name(rawValue: "changed_model")
}
