//
//  CalculationViewController.swift
//  Optimal-Cayo-Perico-Take
//
//  Created by Danny Paez on 3/19/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import UIKit

class CalculationViewController: UIViewController {
    private var lootQuantities: [Int]!
    private var numPlayers: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initVC(lootQuantities: [Int], numPlayers: Int) {
        self.lootQuantities = lootQuantities
        self.numPlayers = numPlayers
    }

}
