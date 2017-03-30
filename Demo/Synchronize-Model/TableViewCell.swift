//
//  TableViewCell.swift
//  Synchronize-Model
//
//  Created by Ayakix on 2017/03/29.
//  Copyright © 2017年 Ayakix. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var favoriteButton: UIButton!
    
    var model: Model!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateView(from model: Model) {
        self.model = model
        titleLabel.text = "id: \(model.id)"
        favoriteButton.isSelected = model.isFavorite
    }
    
    @IBAction private func onFavoriteButtonClick(_ sender: UIButton) {
        model.isFavorite = !sender.isSelected
        ModelNotification.update(model: model)
    }
}
