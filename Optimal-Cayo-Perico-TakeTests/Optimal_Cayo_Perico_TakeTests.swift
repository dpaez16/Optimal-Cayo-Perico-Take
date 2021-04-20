//
//  Optimal_Cayo_Perico_TakeTests.swift
//  Optimal-Cayo-Perico-TakeTests
//
//  Created by Danny Paez on 3/19/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import XCTest
//@testable import Optimal_Cayo_Perico_Take

class Optimal_Cayo_Perico_TakeTests: XCTestCase {
    private let ACCURACY = 0.00001
    private var EMPTY_MULTIPLIERS: [SecondaryLootTypes: Double] = [:]
    
    override func setUp() {
        for lootType in SecondaryLootTypes.allCases {
            EMPTY_MULTIPLIERS[lootType] = 1.0
        }
    }
    
    func testWeightMethods() {
        let capacity: Double = 2
        let lootCounts: [SecondaryLootTypes: Double] = [
            SecondaryLootTypes.Gold: 3,
            SecondaryLootTypes.Art: 0,
            SecondaryLootTypes.Cash: 0,
            SecondaryLootTypes.Coke: 0,
            SecondaryLootTypes.Weed: 0
        ]
        
        let optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: EMPTY_MULTIPLIERS)
        let weightsObtained = OptimalLootUtils.getWeightsObtained(lootGrabbed: optimalLoot)
        let totalWeightObtained = OptimalLootUtils.getTotalWeight(lootGrabbed: optimalLoot)
        
        XCTAssertEqual(optimalLoot[SecondaryLootTypes.Gold]!, 3)
        XCTAssertEqual(weightsObtained[SecondaryLootTypes.Gold], 2)
        XCTAssertEqual(totalWeightObtained, capacity)
    }
    
    func testValueMethods() {
        let capacity: Double = 2
        let lootCounts: [SecondaryLootTypes: Double] = [
            SecondaryLootTypes.Gold: 3,
            SecondaryLootTypes.Art: 0,
            SecondaryLootTypes.Cash: 0,
            SecondaryLootTypes.Coke: 0,
            SecondaryLootTypes.Weed: 0
        ]
        
        let optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: EMPTY_MULTIPLIERS)
        let valuesObtained = OptimalLootUtils.getValuesObtained(lootGrabbed: optimalLoot, lootMultipliers: EMPTY_MULTIPLIERS)
        let totalValuesObtained = OptimalLootUtils.getTotalValues(lootGrabbed: optimalLoot, lootMultipliers: EMPTY_MULTIPLIERS)
        let actualTotalValues = (3 * SecondaryLootTypes.Gold.getMinValue(), 3 * SecondaryLootTypes.Gold.getMaxValue())
        
        XCTAssertEqual(optimalLoot[SecondaryLootTypes.Gold]!, 3)
        XCTAssertEqual(valuesObtained[SecondaryLootTypes.Gold]!.0, actualTotalValues.0)
        XCTAssertEqual(valuesObtained[SecondaryLootTypes.Gold]!.1, actualTotalValues.1)
        XCTAssertEqual(totalValuesObtained.0, actualTotalValues.0)
        XCTAssertEqual(totalValuesObtained.1, actualTotalValues.1)
    }
    
    func testOptimalLootGoldArt() {
        let capacity: Double = 1
        let lootCounts: [SecondaryLootTypes: Double] = [
            SecondaryLootTypes.Gold: 1,
            SecondaryLootTypes.Art: 1,
            SecondaryLootTypes.Cash: 0,
            SecondaryLootTypes.Coke: 0,
            SecondaryLootTypes.Weed: 0
        ]
        
        let optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: EMPTY_MULTIPLIERS)
        for lootType in SecondaryLootTypes.allCases {
            if lootType == .Gold {
                XCTAssertEqual(optimalLoot[lootType]!, 0.75, accuracy: ACCURACY)
            } else if lootType == .Art {
                XCTAssertEqual(optimalLoot[lootType]!, 1, accuracy: ACCURACY)
            } else {
                XCTAssertEqual(optimalLoot[lootType]!, 0, accuracy: ACCURACY)
            }
        }
    }
    
    func testOptimalLootGold() {
        var capacity: Double = 1
        var lootCounts: [SecondaryLootTypes: Double] = [
            SecondaryLootTypes.Gold: 2,
            SecondaryLootTypes.Art: 1,
            SecondaryLootTypes.Cash: 1,
            SecondaryLootTypes.Coke: 0,
            SecondaryLootTypes.Weed: 1
        ]
        
        var optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: EMPTY_MULTIPLIERS)
        for lootType in SecondaryLootTypes.allCases {
            if lootType == .Gold {
                XCTAssertTrue(optimalLoot[lootType]! > 0)
            } else {
                XCTAssertEqual(optimalLoot[lootType]!, 0, accuracy: ACCURACY)
            }
        }
        
        capacity = 2
        lootCounts = [
            SecondaryLootTypes.Gold: 3,
            SecondaryLootTypes.Art: 1,
            SecondaryLootTypes.Cash: 2,
            SecondaryLootTypes.Coke: 1,
            SecondaryLootTypes.Weed: 1
        ]
        
        optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: EMPTY_MULTIPLIERS)
        
        for lootType in SecondaryLootTypes.allCases {
            if lootType == .Gold {
                XCTAssertEqual(optimalLoot[lootType]!, 3, accuracy: ACCURACY)
            } else {
                XCTAssertEqual(optimalLoot[lootType]!, 0, accuracy: ACCURACY)
            }
        }
    }
    
    func testOptimalLootGoldCoke() {
        let capacity: Double = 1
        let lootCounts: [SecondaryLootTypes: Double] = [
            SecondaryLootTypes.Gold: 1,
            SecondaryLootTypes.Art: 1,
            SecondaryLootTypes.Cash: 0,
            SecondaryLootTypes.Coke: 1,
            SecondaryLootTypes.Weed: 1
        ]
        
        let optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: EMPTY_MULTIPLIERS)
        for lootType in SecondaryLootTypes.allCases {
            if lootType == .Gold || lootType == .Coke {
                XCTAssertTrue(optimalLoot[lootType]! > 0)
            } else {
                XCTAssertEqual(optimalLoot[lootType]!, 0, accuracy: ACCURACY)
            }
        }
    }
    
    func testOptimalLootArt() {
        var capacity: Double = 1
        var lootCounts: [SecondaryLootTypes: Double] = [
            SecondaryLootTypes.Gold: 1,
            SecondaryLootTypes.Art: 1,
            SecondaryLootTypes.Cash: 0,
            SecondaryLootTypes.Coke: 0,
            SecondaryLootTypes.Weed: 1
        ]
        
        var optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: EMPTY_MULTIPLIERS)
        for lootType in SecondaryLootTypes.allCases {
            if lootType == .Gold || lootType == .Weed {
                XCTAssertTrue(optimalLoot[lootType]! > 0)
            } else {
                XCTAssertEqual(optimalLoot[lootType]!, 0, accuracy: ACCURACY)
            }
        }
        
        capacity = 1
        lootCounts = [
            SecondaryLootTypes.Gold: 0,
            SecondaryLootTypes.Art: 1,
            SecondaryLootTypes.Cash: 2,
            SecondaryLootTypes.Coke: 1,
            SecondaryLootTypes.Weed: 0
        ]
        
        optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: EMPTY_MULTIPLIERS)
        for lootType in SecondaryLootTypes.allCases {
            if lootType == .Art || lootType == .Coke {
                XCTAssertEqual(optimalLoot[lootType]!, 1, accuracy: ACCURACY)
            } else {
                XCTAssertEqual(optimalLoot[lootType]!, 0, accuracy: ACCURACY)
            }
        }
        
        capacity = 1
        lootCounts = [
            SecondaryLootTypes.Gold: 2,
            SecondaryLootTypes.Art: 4,
            SecondaryLootTypes.Cash: 0,
            SecondaryLootTypes.Coke: 2,
            SecondaryLootTypes.Weed: 0
        ]
        
        optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: EMPTY_MULTIPLIERS)
        for lootType in SecondaryLootTypes.allCases {
            if lootType == .Gold {
                XCTAssertEqual(optimalLoot[lootType]!, 1.5, accuracy: ACCURACY)
            } else {
                XCTAssertEqual(optimalLoot[lootType]!, 0, accuracy: ACCURACY)
            }
        }
    }
    
    func testDivideLoot() {
        var capacity: Double = 3
        var lootCounts: [SecondaryLootTypes: Double] = [
            SecondaryLootTypes.Gold: 0,
            SecondaryLootTypes.Art: 6,
            SecondaryLootTypes.Cash: 0,
            SecondaryLootTypes.Coke: 0,
            SecondaryLootTypes.Weed: 0
        ]
        
        var optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: EMPTY_MULTIPLIERS)
        var playerLoots = OptimalLootUtils.divideLoot(among: Int(capacity), lootGrabbed: optimalLoot, lootMultipliers: EMPTY_MULTIPLIERS)
        
        for playerLoot in playerLoots {
            XCTAssertEqual(playerLoot[.Art]!, 2, accuracy: ACCURACY)
        }
        
        capacity = 2
        lootCounts = [
            SecondaryLootTypes.Gold: 3,
            SecondaryLootTypes.Art: 0,
            SecondaryLootTypes.Cash: 0,
            SecondaryLootTypes.Coke: 0,
            SecondaryLootTypes.Weed: 0
        ]
        
        optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: EMPTY_MULTIPLIERS)
        playerLoots = OptimalLootUtils.divideLoot(among: Int(capacity), lootGrabbed: optimalLoot, lootMultipliers: EMPTY_MULTIPLIERS)
        
        for playerLoot in playerLoots {
            XCTAssertEqual(playerLoot[.Gold]!, 1.5, accuracy: ACCURACY)
        }
    }
    
    func testReformatNumber() {
        var num: Double = 1234.156
        var numStr: String = OptimalLootUtils.reformatNumber(num: num, numberStyle: .currency)
        XCTAssertEqual(numStr, "$1,234.16")
        
        num = 2 / 3
        numStr = OptimalLootUtils.reformatNumber(num: num, numberStyle: .percent)
        XCTAssertEqual(numStr, "66.67%")
        
        num = 1.0
        numStr = OptimalLootUtils.reformatNumber(num: num, numberStyle: .decimal)
        XCTAssertEqual(numStr, "1")
    }
    
    func testMultipliers() {
        let capacity: Double = 1
        let lootCounts: [SecondaryLootTypes: Double] = [
            SecondaryLootTypes.Gold: 2,
            SecondaryLootTypes.Art: 0,
            SecondaryLootTypes.Coke: 2,
            SecondaryLootTypes.Weed: 2,
            SecondaryLootTypes.Cash: 0
        ]
        
        // 4/20 special
        let lootMulitpliers: [SecondaryLootTypes: Double] = [
            .Gold: 1,
            .Art: 1,
            .Coke: 1,
            .Weed: 2,
            .Cash: 1
        ]
        
        // weed is more important than gold due to weed multiplier
        let optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: lootMulitpliers)
        for lootType in SecondaryLootTypes.allCases {
            if lootType == .Gold {
                XCTAssertTrue(optimalLoot[lootType]! > 0)
            } else if lootType == .Weed {
                XCTAssertEqual(optimalLoot[lootType]!, lootCounts[.Weed]!, accuracy: ACCURACY)
            } else {
                XCTAssertEqual(optimalLoot[lootType]!, 0, accuracy: ACCURACY)
            }
        }
        
        XCTAssertTrue(optimalLoot[.Weed]! > optimalLoot[.Gold]!)
    }
}
