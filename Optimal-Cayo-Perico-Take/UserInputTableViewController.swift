//
//  UserInputTableViewController.swift
//  Optimal-Cayo-Perico-Take
//
//  Created by Danny Paez on 3/19/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import UIKit

class UserInputTableViewController: UITableViewController {
    static var lootQuantities: [Int] = Array(repeating: 0, count: SecondaryLootTypes.allCases.count)
    static var numPlayers: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = true
        self.tableView.isScrollEnabled = false
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StepperTypes.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userInputCell", for: indexPath)
        
        if let cell = cell as? UserInputTableViewCell {
            let idx = indexPath.row
            let stepperType = StepperTypes.allCases[idx]
            cell.initCell(stepperType: stepperType, navigationController: navigationController ?? nil)
        }
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "calculateOptimalLootSegue" else { return }
        guard let vc = segue.destination as? CalculationViewController else { return }
        
        let lootQuantities = UserInputTableViewController.lootQuantities
        let numPlayers = UserInputTableViewController.numPlayers
        
        vc.initVC(lootQuantities: lootQuantities, numPlayers: numPlayers)
    }

}
