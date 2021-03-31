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
    
    func testWeightMethods() {
        let capacity: Double = 2
        let lootCounts: [SecondaryLootTypes: Double] = [
            SecondaryLootTypes.Gold: 3,
            SecondaryLootTypes.Art: 0,
            SecondaryLootTypes.Cash: 0,
            SecondaryLootTypes.Coke: 0,
            SecondaryLootTypes.Weed: 0
        ]
        
        let optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts)
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
        
        let optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts)
        let valuesObtained = OptimalLootUtils.getValuesObtained(lootGrabbed: optimalLoot)
        let totalValuesObtained = OptimalLootUtils.getTotalValues(lootGrabbed: optimalLoot)
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
        
        let optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts)
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
        
        var optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts)
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
        
        optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts)
        
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
        
        let optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts)
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
        
        var optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts)
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
        
        optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts)
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
        
        optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts)
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
        
        var optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts)
        var playerLoots = OptimalLootUtils.divideLoot(among: Int(capacity), lootGrabbed: optimalLoot)
        
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
        
        optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts)
        playerLoots = OptimalLootUtils.divideLoot(among: Int(capacity), lootGrabbed: optimalLoot)
        
        for playerLoot in playerLoots {
            XCTAssertEqual(playerLoot[.Gold]!, 1.5, accuracy: ACCURACY)
        }
    }
}
