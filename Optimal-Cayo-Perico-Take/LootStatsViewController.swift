//
//  LootStatsViewController.swift
//  Optimal-Cayo-Perico-Take
//
//  Created by Danny Paez on 3/30/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import UIKit

class LootStatsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var weights: [Double] = []
    private var values: [(Double, Double)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.reloadData()
    }
    
    func initVC(playerLoots: [[SecondaryLootTypes: Double]], lootMultipliers: [SecondaryLootTypes: Double]) {
        self.weights = playerLoots.map { lootGrabbed in OptimalLootUtils.getTotalWeight(lootGrabbed: lootGrabbed) }
        self.values = playerLoots.map { lootGrabbed in OptimalLootUtils.getTotalValues(lootGrabbed: lootGrabbed, lootMultipliers: lootMultipliers) }
    }
}

extension LootStatsViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weights.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getPlayerStatCell(indexPath: IndexPath) -> UITableViewCell {
        let idx = indexPath.row
        let playerNum = idx + 1
        let totalValues = self.values[idx]
        let minValue = OptimalLootUtils.reformatNumber(num: totalValues.0, numberStyle: .currency)
        let maxValue = OptimalLootUtils.reformatNumber(num: totalValues.1, numberStyle: .currency)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerStatsCell", for: indexPath)
        cell.textLabel?.text = "Player \(playerNum): \(minValue) - \(maxValue)"
        return cell
    }
    
    func getTotalStatCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "totalStatsCell", for: indexPath)
        let totalValues = self.values.reduce((0.0, 0.0)) {totals, curr in (totals.0 + curr.0, totals.1 + curr.1)}
        let minValue = OptimalLootUtils.reformatNumber(num: totalValues.0, numberStyle: .currency)
        let maxValue = OptimalLootUtils.reformatNumber(num: totalValues.1, numberStyle: .currency)
        
        cell.textLabel?.text = "Total: \(minValue) - \(maxValue)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idx = indexPath.row
        if idx < self.weights.count {
            return getPlayerStatCell(indexPath: indexPath)
        } else {
            return getTotalStatCell(indexPath: indexPath)
        }
    }
}
