//
//  DetailViewController.swift
//  Synchronize-Model
//
//  Created by Ayakix on 2017/03/29.
//  Copyright © 2017年 Ayakix. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var favoriteButton: UIButton!
    
    var someModel: SomeModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "id: \(someModel.id)"
        favoriteButton.isSelected = someModel.isFavorite
    }

    @IBAction private func onFavoriteButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        someModel.isFavorite = sender.isSelected
        NotificationUtil.notifyModelChange(someModel: someModel, eventType: .update)
    }
    
    @IBAction private func onDeleteButtonClick(_ sender: UIButton) {
        NotificationUtil.notifyModelChange(someModel: someModel, eventType: .delete)
    }
}
