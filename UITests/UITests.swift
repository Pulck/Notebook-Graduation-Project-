//
//  UITests.swift
//  UITests
//
//  Created by Colick on 2018/6/8.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import XCTest

class UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Shortcut"].tap()
        XCUIDevice.shared.orientation = .portrait
        tabBarsQuery.buttons["Notebook"].tap()
        XCUIDevice.shared.orientation = .faceUp
        XCUIDevice.shared.orientation = .portrait
        app.tables.otherElements["Notebook"].children(matching: .button).element.tap()
        XCUIDevice.shared.orientation = .faceUp
        app.textFields["Notebook Name"].tap()
        app.navigationBars["Notebook_Graduation_Project_.CreateNotebookView"].buttons["Cancel"].tap()
        XCUIDevice.shared.orientation = .faceUp
        
        app.tabBars.children(matching: .button).element(boundBy: 1).tap()
        app.tables["Notebook"].children(matching: .button).element.tap()
        app.textFields["Notebook Name"].tap()
        
        
    }
    
}
