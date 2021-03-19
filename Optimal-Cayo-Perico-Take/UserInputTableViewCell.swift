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
    private var navigationController: UINavigationController?
    
    func initCell(stepperType: StepperTypes, navigationController: UINavigationController?) {
        self.stepperType = stepperType
        self.navigationController = navigationController
        stepper.isContinuous = false
        stepper.stepValue = 1
        stepper.minimumValue = stepperType == StepperTypes.Players ? 1 : 0
        stepper.maximumValue = stepperType == StepperTypes.Players ? 4 : 10
        userInputLabel.text = getProperLabelStr()
    }
    
    func getProperLabelStr() -> String {
        let stepperValue: Int = getStepperQuantity()
        return "\(stepperType.rawValue): \(stepperValue)"
    }
    
    func getStepperQuantity() -> Int {
        return Int(stepper.value)
    }
    
    @IBAction func changedStepperValue(_ sender: UIStepper) {
        if stepperType != StepperTypes.Players, let navigationController = navigationController {
            let idx = (SecondaryLootTypes.allCases.map { lootType in lootType.rawValue }).firstIndex(of: stepperType.rawValue)!
            UserInputTableViewController.lootQuantities[idx] = getStepperQuantity()
    
            // make sure at least one loot type is there to make the calculation work
            navigationController.isToolbarHidden = UserInputTableViewController.lootQuantities.reduce(true) { flag, lootQuantity in flag && lootQuantity == 0 }
        } else if stepperType == StepperTypes.Players {
            UserInputTableViewController.numPlayers = getStepperQuantity()
        }
        
        userInputLabel.text = getProperLabelStr()
    }
    
}
