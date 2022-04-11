//
//  PlayerLootTableViewCell.swift
//  Optimal-Cayo-Perico-Take
//
//  Created by Danny Paez on 3/31/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import UIKit

class PlayerLootTableViewCell: UITableViewCell {
    private var lootType: SecondaryLootTypes!
    private var lootQuantity: String!
    
    func initCell(lootType: SecondaryLootTypes, lootQuantity: Double) {
        self.lootType = lootType
        self.lootQuantity = OptimalLootUtils.reformatNumber(num: lootQuantity, numberStyle: .decimal)
        self.imageView?.image = UIImage(named: self.lootType.rawValue)
        let lootNoun = self.lootType != .Art ? "piles" : (self.lootQuantity != "1" ? "paintings" : "painting")
        self.textLabel?.text = "\(self.lootType!): \(self.lootQuantity!) \(lootNoun)"
    }
}
