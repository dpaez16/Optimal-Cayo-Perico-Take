//
//  PlayerLootViewController.swift
//  Optimal-Cayo-Perico-Take
//
//  Created by Danny Paez on 3/30/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import UIKit

class PlayerLootViewController: UIViewController {
    @IBOutlet weak var playerNumLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var playerNum: Int = 0
    private var actualPlayerLoot: [SecondaryLootTypes: Double] = [:]
    private var numLootItems: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playerNumLabel.text = "Player \(playerNum):"
        self.tableView.reloadData()
    }
    
    func initVC(playerNum: Int, playerLoot: [SecondaryLootTypes: Double]) {
        self.playerNum = playerNum
        
        for lootType in playerLoot.keys {
            if playerLoot[lootType] != 0 {
                self.actualPlayerLoot[lootType] = playerLoot[lootType]
                self.numLootItems += 1
            }
        }
    }
    
}

extension PlayerLootViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numLootItems + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getPlayerLootIndex(playerLoot: [SecondaryLootTypes: Double], idx: Int) -> SecondaryLootTypes {
        for (i, lootType) in playerLoot.keys.enumerated() {
            if i == idx {
                return lootType
            }
        }
        
        return SecondaryLootTypes.Art
    }
    
    func getPlayerLootCell(indexPath: IndexPath) -> UITableViewCell {
        let idx = indexPath.row
        let lootType = getPlayerLootIndex(playerLoot: actualPlayerLoot, idx: idx)
        let lootQuantity = actualPlayerLoot[lootType]!
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "playerLootCell", for: indexPath) as? PlayerLootTableViewCell {
            cell.initCell(lootType: lootType, lootQuantity: lootQuantity)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func getPlayerLootWeightCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerLootWeightCell", for: indexPath)
        var weight = OptimalLootUtils.getTotalWeight(lootGrabbed: self.actualPlayerLoot) * 100
        weight = OptimalLootUtils.round(num: weight, digits: 2)
        
        cell.textLabel?.text = "Total Weight: \(weight)%"
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idx = indexPath.row
        if idx < numLootItems {
            return getPlayerLootCell(indexPath: indexPath)
        } else {
            return getPlayerLootWeightCell(indexPath: indexPath)
        }
    }
}
