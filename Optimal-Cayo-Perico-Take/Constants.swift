//
//  Constants.swift
//  Optimal-Cayo-Perico-Take
//
//  Created by Danny Paez on 3/19/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import Foundation

let MIN_PLAYERS: Double = 1
let MAX_PLAYERS: Double = 4
let MIN_LOOT_COUNT: Double = 0
let MAX_LOOT_COUNT: Double = 15

public enum SecondaryLootTypes: String, CaseIterable {
    case Gold
    case Art
    case Coke
    case Weed
    case Cash
    
    private func getLootParams() -> ((Double, Double), Double) {
        switch self {
        case .Gold:
            return ((328584, 333192), 2 / 3)
        case .Art:
            return ((176200, 199700), 0.5)
        case .Coke:
            return ((220500, 225000), 0.5)
        case .Weed:
            return ((145980, 149265), 0.375)
        case .Cash:
            return ((78480, 89420), 0.25)
        }
    }
    
    func getMinValue(_ moneyMultipler: Double = 1.0) -> Double {
        return self.getLootParams().0.0 * moneyMultipler
    }
    
    func getMaxValue(_ moneyMultipler: Double = 1.0) -> Double {
        return self.getLootParams().0.1 * moneyMultipler
    }
    
    func getWeight() -> Double {
        return self.getLootParams().1
    }
}

public enum StepperTypes: String, CaseIterable {
    case Gold
    case Art
    case Coke
    case Weed
    case Cash
    case Players
}
