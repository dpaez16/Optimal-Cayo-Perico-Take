//
//  PlayerLootTableViewCell.swift
//  Optimal-Cayo-Perico-Take
//
//  Created by Danny Paez on 3/31/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import UIKit

class PlayerLootTableViewCell: UITableViewCell {
    @IBOutlet weak var playerLootLabel: UILabel!
    private var lootType: SecondaryLootTypes!
    private var lootQuantity: Double!
    
    func initCell(lootType: SecondaryLootTypes, lootQuantity: Double) {
        self.lootType = lootType
        self.lootQuantity = OptimalLootUtils.round(num: lootQuantity, digits: 2)
        
        if lootType == .Art {
            playerLootLabel.text = "\(self.lootType!): \(Int(self.lootQuantity!))"
        } else {
            playerLootLabel.text = "\(self.lootType!): \(self.lootQuantity!)"
        }
    }
}
