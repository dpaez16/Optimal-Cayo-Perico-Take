//
//  OptimalLootUtils.swift
//  Optimal-Cayo-Perico-Take
//
//  Created by Danny Paez on 3/19/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import Foundation

class OptimalLootUtils {
    static func fractionalKnapsack(capacity: Double, weights: [Double], values: [Double], lootItems: [SecondaryLootTypes]) -> [Double] {
        let idxs = weights.indices
        var ratioTuples = idxs.map { ($0, values[$0] / weights[$0]) }
        ratioTuples.sort {lhs, rhs in lhs.1 > rhs.1} // sort in decreasing order
        
        var itemsUsed = Array(repeating: 0.0, count: weights.count)
        var currCapacity = capacity
        
        for ratioTuple in ratioTuples {
            let idx = ratioTuple.0
            
            if currCapacity - weights[idx] >= 0 {
                currCapacity -= weights[idx]
                itemsUsed[idx] = 1
            } else if lootItems[idx] != .Art {
                itemsUsed[idx] = currCapacity / weights[idx]
                currCapacity = 0
            } else {
                itemsUsed[idx] = 0
            }
        }
        
        return itemsUsed
    }
    
    static func getValuesObtained(lootGrabbed: [SecondaryLootTypes: Double]) -> [SecondaryLootTypes: (Double, Double)] {
        var valuesObtained: [SecondaryLootTypes: (Double, Double)] = [:]
        
        for lootType in lootGrabbed.keys {
            let lowerBound = lootType.getLootParams().0.0
            let upperBound = lootType.getLootParams().0.1
            valuesObtained[lootType] = (lootGrabbed[lootType]! * lowerBound, lootGrabbed[lootType]! * upperBound)
        }
        
        return valuesObtained
    }
    
    static func getTotalValues(lootGrabbed: [SecondaryLootTypes: Double]) -> (Double, Double) {
        return lootGrabbed.keys.reduce((0.0, 0.0)) { totals, lootType in
            let lowerBound = lootType.getLootParams().0.0
            let upperBound = lootType.getLootParams().0.1
            return (totals.0 + lootGrabbed[lootType]! * lowerBound, totals.1 + lootGrabbed[lootType]! * upperBound)
        }
    }
    
    static func getWeightsObtained(lootGrabbed: [SecondaryLootTypes: Double]) -> [SecondaryLootTypes: Double] {
        var weightsObtained: [SecondaryLootTypes: Double] = [:]
        
        for lootType in lootGrabbed.keys {
            weightsObtained[lootType] = lootGrabbed[lootType]! * lootType.getLootParams().1
        }
        
        return weightsObtained
    }
    
    static func getTotalWeight(lootGrabbed: [SecondaryLootTypes: Double]) -> Double {
        return lootGrabbed.keys.reduce(0.0) { total, lootType in total + lootGrabbed[lootType]! * lootType.getLootParams().1 }
    }
    
    static func getOptimalLoot(capacity: Double, lootCounts: [SecondaryLootTypes: Double]) -> [SecondaryLootTypes: Double] {
        let missingLootTypes = SecondaryLootTypes.allCases.filter { lootType in lootCounts[lootType] == 0 }
        let presentLootTypes = SecondaryLootTypes.allCases.filter { lootType in lootCounts[lootType] != 0 }
        
        let weights = presentLootTypes.map { lootType in lootType.getLootParams().1 * (lootCounts[lootType]!) }
        let values = presentLootTypes.map { lootType in lootType.getLootParams().0.1 * (lootCounts[lootType]!) }
        
        let itemsUsed = fractionalKnapsack(capacity: capacity, weights: weights, values: values, lootItems: presentLootTypes)
        
        var optimalLoot: [SecondaryLootTypes: Double] = [:]
        for (idx, lootType) in presentLootTypes.enumerated() {
            optimalLoot[lootType] = itemsUsed[idx] * (lootCounts[lootType]!)
        }
        
        for lootType in missingLootTypes {
            optimalLoot[lootType] = 0
        }
        
        return optimalLoot
    }
}
