//
//  Optimal_Cayo_Perico_TakeUITests.swift
//  Optimal-Cayo-Perico-TakeUITests
//
//  Created by Danny Paez on 3/19/21.
//  Copyright © 2021 Danny Paez. All rights reserved.
//

import XCTest

class Optimal_Cayo_Perico_TakeUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }
    
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Calculate button should not appear when the app starts
        let tablesQuery = XCUIApplication().tables
        XCTAssertFalse(app.toolbars["Toolbar"].exists)
        
        for stepperType in StepperTypes.allCases {
            // trying to increment each stepper by 1
            let originalQuantity = stepperType == StepperTypes.Players ? 1 : 0
            let idString = "\(stepperType.rawValue): \(originalQuantity)"
            
            tablesQuery.cells.containing(.staticText, identifier: idString).buttons["Increment"].tap()
            XCTAssert(tablesQuery.cells.containing(.staticText, identifier: idString).count == 0)
            
            // if any loot type is > 1, the calculate button should appear
            XCTAssert(app.toolbars["Toolbar"].exists)
        }
        
        // calculate button should still appear, as the loot types have been incremented
        XCTAssert(app.toolbars["Toolbar"].exists)
        app.toolbars["Toolbar"].buttons["Calculate Optimal Loot"].tap()
        app.navigationBars["Optimal_Cayo_Perico_Take.CalculationView"].buttons["Back"].tap()
    }
}
