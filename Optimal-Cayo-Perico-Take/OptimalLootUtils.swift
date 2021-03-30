//
//  OptimalLootUtils.swift
//  Optimal-Cayo-Perico-Take
//
//  Created by Danny Paez on 3/19/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import Foundation

class OptimalLootUtils {
    static func fractionalKnapsack(capacity: Double, weights: [Double], values: [Double]) -> [Double] {
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
            } else {
                itemsUsed[idx] = currCapacity / weights[idx]
                currCapacity = 0
            }
        }
        
        return itemsUsed
    }
    
    static func getValuesObtained(lootGrabbed: [SecondaryLootTypes: Double]) -> [SecondaryLootTypes: (Double, Double)] {
        var valuesObtained: [SecondaryLootTypes: (Double, Double)] = [:]
        
        for lootType in lootGrabbed.keys {
            let lowerBound = lootType.getMinValue()
            let upperBound = lootType.getMaxValue()
            valuesObtained[lootType] = (lootGrabbed[lootType]! * lowerBound, lootGrabbed[lootType]! * upperBound)
        }
        
        return valuesObtained
    }
    
    static func getTotalValues(lootGrabbed: [SecondaryLootTypes: Double]) -> (Double, Double) {
        return lootGrabbed.keys.reduce((0.0, 0.0)) { totals, lootType in
            let lowerBound = lootType.getMinValue()
            let upperBound = lootType.getMaxValue()
            return (totals.0 + lootGrabbed[lootType]! * lowerBound, totals.1 + lootGrabbed[lootType]! * upperBound)
        }
    }
    
    static func getWeightsObtained(lootGrabbed: [SecondaryLootTypes: Double]) -> [SecondaryLootTypes: Double] {
        var weightsObtained: [SecondaryLootTypes: Double] = [:]
        
        for lootType in lootGrabbed.keys {
            weightsObtained[lootType] = lootGrabbed[lootType]! * lootType.getWeight()
        }
        
        return weightsObtained
    }
    
    static func getTotalWeight(lootGrabbed: [SecondaryLootTypes: Double]) -> Double {
        return lootGrabbed.keys.reduce(0.0) { total, lootType in total + lootGrabbed[lootType]! * lootType.getWeight() }
    }
    
    private static func getOptimalLootHelper(capacity: Double, lootCounts: [SecondaryLootTypes: Double]) -> [SecondaryLootTypes: Double] {
        let missingLootTypes = SecondaryLootTypes.allCases.filter { lootType in lootCounts[lootType] == 0 }
        let presentLootTypes = SecondaryLootTypes.allCases.filter { lootType in lootCounts[lootType] != 0 }
        
        let weights = presentLootTypes.map { lootType in lootType.getWeight() * (lootCounts[lootType]!) }
        let values = presentLootTypes.map { lootType in lootType.getMaxValue() * (lootCounts[lootType]!) }
        
        let itemsUsed = fractionalKnapsack(capacity: capacity, weights: weights, values: values)
        
        var optimalLoot: [SecondaryLootTypes: Double] = [:]
        for (idx, lootType) in presentLootTypes.enumerated() {
            optimalLoot[lootType] = itemsUsed[idx] * (lootCounts[lootType]!)
        }
        
        for lootType in missingLootTypes {
            optimalLoot[lootType] = 0
        }
        
        return optimalLoot
    }
    
    private static func getOptimalNumArtItems(capacity: Double, lootCounts: [SecondaryLootTypes: Double]) -> Double {
        let maxNumArtItems = Int(lootCounts[.Art]!)
        let artWeight = SecondaryLootTypes.Art.getWeight()
        let artValues = (SecondaryLootTypes.Art.getMinValue(), SecondaryLootTypes.Art.getMaxValue())
        var choices: [(Double, Double)] = []
        var lootCountsCopy = lootCounts
        lootCountsCopy[.Art] = 0
        
        for numArtItems in 0 ... maxNumArtItems {
            let numArtItemsDbl = Double(numArtItems)
            let alteredCapacity = capacity - artWeight * numArtItemsDbl
            let optimalLoot = getOptimalLootHelper(capacity: alteredCapacity, lootCounts: lootCountsCopy)
            var totalValues = getTotalValues(lootGrabbed: optimalLoot)
            totalValues = (totalValues.0 + artValues.0 * numArtItemsDbl, totalValues.1 + artValues.1 * numArtItemsDbl)
            
            choices.append(totalValues)
        }
        
        let indices = choices.indices
        let numArtItems = indices.max { choices[$0].1 < choices[$1].1 }
        let numArtItemsDbl = Double(numArtItems!)
        
        return numArtItemsDbl
    }
    
    static func getOptimalLoot(capacity: Double, lootCounts: [SecondaryLootTypes: Double]) -> [SecondaryLootTypes: Double] {
        let numArtItems = getOptimalNumArtItems(capacity: capacity, lootCounts: lootCounts)
        let artWeight = SecondaryLootTypes.Art.getWeight()
        var lootCountsCopy = lootCounts
        lootCountsCopy[.Art] = 0
        
        let alteredCapacity = capacity - artWeight * numArtItems
        var optimalLoot = getOptimalLootHelper(capacity: alteredCapacity, lootCounts: lootCountsCopy)
        optimalLoot[.Art] = numArtItems
        
        return optimalLoot
    }
}
