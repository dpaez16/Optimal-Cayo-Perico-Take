//
//  Constants.swift
//  Optimal-Cayo-Perico-Take
//
//  Created by Danny Paez on 3/19/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import Foundation

public enum SecondaryLootTypes: String, CaseIterable {
    case Gold
    case Art
    case Coke
    case Weed
    case Cash
    
    func getLootParams() -> ((Double, Double), Double) {
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
}

public enum StepperTypes: String, CaseIterable {
    case Gold
    case Art
    case Coke
    case Weed
    case Cash
    case Players
}
