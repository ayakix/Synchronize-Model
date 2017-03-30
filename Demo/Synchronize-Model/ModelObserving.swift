//
//  ModelObserving.swift
//  Synchronize-Model
//
//  Created by r_ayaki on 2017/03/30.
//  Copyright © 2017年 Ayakix. All rights reserved.
//

import UIKit

protocol ModelObserving {
    func addDidChangeModelObserver(notificationCenter: NotificationCenter)
    func removeDidChangeModelObserver(notificationCenter: NotificationCenter)
    func didChangeModel(_ notification: Notification)
}

// MARK: - UIViewController

extension UIViewController: ModelObserving {
    func addDidChangeModelObserver(notificationCenter: NotificationCenter = NotificationCenter.default) {
        notificationCenter.addObserver(self, selector: #selector(didChangeModel(_:)), name: .didChangeModel, object: nil)
    }
    
    func removeDidChangeModelObserver(notificationCenter: NotificationCenter = NotificationCenter.default) {
        notificationCenter.removeObserver(self, name: .didChangeModel, object: nil)
    }
    
    func didChangeModel(_ notification: Notification) {
        guard
            let modelChangeableThing = self as? ModelChangeable,
            let model = ModelNotification.getModel(from: notification),
            let eventType = ModelNotification.getEventType(from: notification) else {
                return
        }
        
        switch eventType {
        case .update:
            modelChangeableThing.updateModel(model)
        case .delete:
            modelChangeableThing.deleteModel(model)
        }
    }
}
