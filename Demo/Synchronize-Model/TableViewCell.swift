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
    
    var someModel: SomeModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateView(with someModel: SomeModel) {
        self.someModel = someModel
        titleLabel.text = "id: \(someModel.id)"
        favoriteButton.isSelected = someModel.isFavorite
    }
    
    @IBAction private func onFavoriteButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}
