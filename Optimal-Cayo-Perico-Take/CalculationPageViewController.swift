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
    private var pages = [UIViewController]()
    
    func initVC(lootQuantities: [Int], numPlayers: Int) {
        self.numPlayers = numPlayers
        
        let capacity = Double(numPlayers)
        var lootCounts: [SecondaryLootTypes: Double] = [:]
        for (idx, lootType) in SecondaryLootTypes.allCases.enumerated() {
            lootCounts[lootType] = Double(lootQuantities[idx])
        }
        
        let optimalLoot = OptimalLootUtils.getOptimalLoot(capacity: capacity, lootCounts: lootCounts)
        let playerLoots = OptimalLootUtils.divideLoot(among: numPlayers, lootGrabbed: optimalLoot)
        let totalValue = OptimalLootUtils.getTotalValues(lootGrabbed: optimalLoot)
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
        for _ in 1 ... numPlayers! {
            let vc = storyboard?.instantiateViewController(identifier: "PlayerLootViewController")
            pages.append(vc!)
        }
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "LootStatsViewController")
        pages.append(vc!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = abs((currentIndex + 1) % pages.count)
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
