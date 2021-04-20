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
    
    func testEntireUIMultipliers() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = XCUIApplication().tables
        
        // make sure gold is initially set to 0 with 1x multiplier
        var labelLoadedProperly = tablesQuery.cells.containing(.staticText, identifier: "Gold: 0").count == 1
        XCTAssertTrue(labelLoadedProperly, "Loot Item is not initially 0")
        
        labelLoadedProperly = tablesQuery.cells.containing(.staticText, identifier: "Gold: 0 [2x $$$]").count == 0
        XCTAssertTrue(labelLoadedProperly, "Multiplier is not set to 1x")
        
        // tap gold
        tablesQuery.cells.containing(.staticText, identifier: "Gold: 0").buttons["Increment"].tap()
        sleep(1)
        
        // make gold multiplier 2x
        tablesQuery.cells.containing(.staticText, identifier: "Gold: 1").element.swipeRight()
        var button = tablesQuery.buttons["2x $$$"]
        button.tap()
        sleep(1)
        
        labelLoadedProperly = tablesQuery.cells.containing(.staticText, identifier: "Gold: 1 [2x $$$]").count == 1
        XCTAssertTrue(labelLoadedProperly, "Multiplier is not set to 2x")
        
        // try to make art multiplier below 1x
        tablesQuery.cells.containing(.staticText, identifier: "Art: 0").element.swipeLeft()
        XCTAssertFalse(tablesQuery.buttons["0x $$$"].waitForExistence(timeout: 1.0), "Multiplier should be capped at 1x")
        XCTAssertFalse(tablesQuery.buttons["1x $$$"].waitForExistence(timeout: 1.0), "Multiplier should be capped at 1x")
        
        // make art multiplier 2x
        tablesQuery.cells.containing(.staticText, identifier: "Art: 0").element.swipeRight()
        button = tablesQuery.buttons["2x $$$"]
        button.tap()
        sleep(1)
        
        // make art multiplier 3x
        tablesQuery.cells.containing(.staticText, identifier: "Art: 0 [2x $$$]").element.swipeRight()
        button = tablesQuery.buttons["3x $$$"]
        button.tap()
        sleep(1)
        
        // try to make art multiplier beyond 3x
        tablesQuery.cells.containing(.staticText, identifier: "Art: 0 [3x $$$]").element.swipeRight()
        XCTAssertFalse(tablesQuery.buttons["4x $$$"].waitForExistence(timeout: 1.0), "Multiplier should be capped at 3x")
        
        // make art multiplier 2x
        tablesQuery.cells.containing(.staticText, identifier: "Art: 0 [3x $$$]").element.swipeLeft()
        button = tablesQuery.buttons["2x $$$"]
        button.tap()
        sleep(1)
        
        // increment art
        tablesQuery.cells.containing(.staticText, identifier: "Art: 0 [2x $$$]").buttons["Increment"].tap()
        sleep(1)
        XCTAssertTrue(tablesQuery.cells.containing(.staticText, identifier: "Art: 1 [2x $$$]").count == 1, "Art not set properly")
        
        // try to swipe right on player row
        tablesQuery.cells.containing(.staticText, identifier: "Players: 1").element.swipeLeft()
        XCTAssertFalse(tablesQuery.buttons["0x $$$"].waitForExistence(timeout: 1.0), "Players row should not have left swipe actions")
        XCTAssertFalse(tablesQuery.buttons["1x $$$"].waitForExistence(timeout: 1.0), "Players row should not have left swipe actions")
        
        // try to swipe right on player row
        tablesQuery.cells.containing(.staticText, identifier: "Players: 1").element.swipeRight()
        XCTAssertFalse(tablesQuery.buttons["3x $$$"].waitForExistence(timeout: 1.0), "Players row should not have right swipe actions")
        XCTAssertFalse(tablesQuery.buttons["4x $$$"].waitForExistence(timeout: 1.0), "Players row should not have right swipe actions")
        
        // tap calculate button
        app.toolbars["Toolbar"].buttons["Calculate Optimal Loot"].tap()
        sleep(1)
        
        // exit app
        app.navigationBars["Optimal_Cayo_Perico_Take.CalculationPageView"].buttons["Back"].tap()
    }
}
