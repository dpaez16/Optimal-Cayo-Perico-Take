//
//  CalculationPageViewController.swift
//  Optimal-Cayo-Perico-Take
//
//  Created by Danny Paez on 3/19/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import UIKit

class CalculationPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    private var numPlayers: Int!
    private var playerLoots: [[SecondaryLootTypes: Double]]!
    private var lootMultipliers: [SecondaryLootTypes: Double] = [:]
    private var pages = [UIViewController]()
    
    func initVC(lootQuantities: [Int], lootMultipliers: [Double], numPlayers: Int) {
        self.numPlayers = numPlayers
        
        let capacity = Double(numPlayers)
        var lootCounts: [SecondaryLootTypes: Double] = [:]
        
        for (idx, lootType) in SecondaryLootTypes.allCases.enumerated() {
            lootCounts[lootType] = Double(lootQuantities[idx])
            self.lootMultipliers[lootType] = lootMultipliers[idx]
        }
        
        let optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts, lootMultipliers: self.lootMultipliers)
        self.playerLoots = OptimalLootUtils.divideLoot(among: numPlayers, lootGrabbed: optimalLoot, lootMultipliers: self.lootMultipliers)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        setUpPages()
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setUpPages() {
        for playerNum in 1 ... numPlayers! {
            guard let vc = storyboard?.instantiateViewController(identifier: "PlayerLootViewController") as PlayerLootViewController? else {
                return
            }
            
            let idx = playerNum - 1
            let playerLoot = self.playerLoots[idx]
            vc.initVC(playerNum: playerNum, playerLoot: playerLoot)
            pages.append(vc)
        }
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "LootStatsViewController") as! LootStatsViewController? else {
            return
        }
        
        vc.initVC(playerLoots: playerLoots, lootMultipliers: self.lootMultipliers)
        pages.append(vc)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else { return nil }
        let previousIndex = (currentIndex - 1) % pages.count
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex + 1 < pages.count else { return nil }
        let nextIndex = (currentIndex + 1) % pages.count
        return pages[nextIndex]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let vc = pages.first, let firstVCIndex = pages.firstIndex(of: vc) else {
            return 0
        }
        
        return firstVCIndex
    }

}
