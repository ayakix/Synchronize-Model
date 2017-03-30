//
//  ModelNotification.swift
//  Synchronize-Model
//
//  Created by r_ayaki on 2017/03/30.
//  Copyright © 2017年 Ayakix. All rights reserved.
//

import Foundation

enum NotificationEventType: Int {
    case update
    case delete
}

private enum NotificationInfoKey: String {
    case model
    case eventType
}

extension NSNotification.Name {
    static let didChangeModel = Notification.Name(rawValue: "changed_model")
}

struct ModelNotification {
    static func update(model: Model) {
        post(model: model, eventType: .update)
    }
    
    static func delete(model: Model) {
        post(model: model, eventType: .delete)
    }
    
    private static func post(model: Model, eventType: NotificationEventType) {
        let userInfo: [String: Any] = [
            NotificationInfoKey.model.rawValue: model,
            NotificationInfoKey.eventType.rawValue: eventType
        ]
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didChangeModel, object: nil, userInfo: userInfo)
        }
    }
    
    static func getModel(from notification: Notification) -> Model? {
        guard
            let userInfo = notification.userInfo,
            let model = userInfo[NotificationInfoKey.model.rawValue] as? Model else {
                return nil
        }
        return model
    }
    
    static func getEventType(from notification: Notification) -> NotificationEventType? {
        guard
            let userInfo = notification.userInfo,
            let eventType = userInfo[NotificationInfoKey.eventType.rawValue] as? NotificationEventType else {
                return nil
        }
        return eventType
    }
}
