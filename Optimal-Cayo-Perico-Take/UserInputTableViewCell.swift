//
//  UserInputTableViewCell.swift
//  Optimal-Cayo-Perico-Take
//
//  Created by Danny Paez on 3/19/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import UIKit

class UserInputTableViewCell: UITableViewCell {
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var userInputLabel: UILabel!
    private var stepperType: StepperTypes!
    private var stepperValue: Int!
    private var navigationController: UINavigationController?
    
    func initCell(stepperType: StepperTypes, navigationController: UINavigationController?) {
        self.stepperType = stepperType
        self.navigationController = navigationController
        stepper.isContinuous = false
        stepper.stepValue = 1
        stepper.minimumValue = stepperType == StepperTypes.Players ? MIN_PLAYERS : MIN_LOOT_COUNT
        stepper.maximumValue = stepperType == StepperTypes.Players ? MAX_PLAYERS : MAX_LOOT_COUNT
        stepper.value = getStepperQuantityAlt()
        userInputLabel.text = getProperLabelStr()
    }
    
    func getProperLabelStr() -> String {
        let stepperValue: Int = getStepperQuantity()
        let idx = getIdx()
        let lootMultiplier: Int = Int(UserInputTableViewController.lootMultipliers[idx])
        
        var labelStr = "\(stepperType.rawValue): \(stepperValue)"
        if lootMultiplier != 1 {
            labelStr += " [\(lootMultiplier)x $$$]"
        }
        
        return labelStr
    }
    
    func getStepperQuantityAlt() -> Double {
        let idx = getIdx()
        if stepperType == StepperTypes.Players {
            return Double(UserInputTableViewController.numPlayers)
        } else {
            return Double(UserInputTableViewController.lootQuantities[idx])
        }
    }
    
    func getStepperQuantity() -> Int {
        return Int(stepper.value)
    }
    
    func getIdx() -> Int {
        guard let idx = (SecondaryLootTypes.allCases.map { lootType in lootType.rawValue }).firstIndex(of: stepperType.rawValue) else {
            return 0
        }
        
        return idx
    }
    
    @IBAction func changedStepperValue(_ sender: UIStepper) {
        if stepperType != StepperTypes.Players, let navigationController = navigationController {
            let idx = getIdx()
            UserInputTableViewController.lootQuantities[idx] = getStepperQuantity()
    
            // make sure at least one loot type is there to make the calculation work
            navigationController.isToolbarHidden = UserInputTableViewController.lootQuantities.reduce(true) { flag, lootQuantity in flag && lootQuantity == 0 }
        } else if stepperType == StepperTypes.Players {
            UserInputTableViewController.numPlayers = getStepperQuantity()
        }
        
        userInputLabel.text = getProperLabelStr()
    }
    
}
