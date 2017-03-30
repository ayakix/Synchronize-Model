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
    
    var model: Model! {
        didSet {
            if favoriteButton?.isSelected != model.isFavorite {
                favoriteButton?.isSelected = model.isFavorite
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "id: \(model.id)"
        favoriteButton.isSelected = model.isFavorite
    }
    
    @IBAction private func onFavoriteButtonClick(_ sender: UIButton) {
        model.isFavorite = !sender.isSelected
        ModelNotification.update(model: model)
    }
    
    @IBAction private func onDeleteButtonClick(_ sender: UIButton) {
        ModelNotification.delete(model: model)
    }
}
