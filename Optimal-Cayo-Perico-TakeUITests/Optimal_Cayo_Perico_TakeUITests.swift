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
    
    func testEntireUI() throws {
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
        
        // calculation screen should appear
        app.toolbars["Toolbar"].buttons["Calculate Optimal Loot"].tap()
        let elementsQuery = app.scrollViews.otherElements
        var pageLoaded = elementsQuery.staticTexts["Player 1:"].waitForExistence(timeout: 1.0)
        XCTAssertTrue(pageLoaded, "Player 1 loot page not loaded")
        
        // try to swipe behind the first screen
        elementsQuery.staticTexts["Player 1:"].swipeRight()
        pageLoaded = elementsQuery.staticTexts["Player 1:"].waitForExistence(timeout: 1.0)
        XCTAssertTrue(pageLoaded, "Player 1 loot page not loaded")
        
        // scroll to Player 2
        elementsQuery.staticTexts["Player 1:"].swipeLeft()
        pageLoaded = elementsQuery.staticTexts["Player 2:"].waitForExistence(timeout: 1.0)
        XCTAssertTrue(pageLoaded, "Player 2 loot page not loaded")
        
        // scroll to stats page
        elementsQuery.staticTexts["Player 2:"].swipeLeft()
        pageLoaded = elementsQuery.staticTexts["Overall Stats:"].waitForExistence(timeout: 1.0)
        XCTAssertTrue(pageLoaded, "Overall Stats page not loaded")
        
        // try to swipe beyond last page
        elementsQuery.staticTexts["Overall Stats:"].swipeLeft()
        pageLoaded = elementsQuery.staticTexts["Overall Stats:"].waitForExistence(timeout: 1.0)
        XCTAssertTrue(pageLoaded, "Overall Stats page not loaded")
        
        // swipe back to initial page
        elementsQuery.staticTexts["Overall Stats:"].swipeRight()
        sleep(1)
        
        elementsQuery.staticTexts["Player 2:"].swipeRight()
        sleep(1)
        
        elementsQuery.staticTexts["Player 1:"].swipeRight()
        sleep(1)
        
        // exit app
        app.navigationBars["Optimal_Cayo_Perico_Take.CalculationPageView"].buttons["Back"].tap()
    }
}
