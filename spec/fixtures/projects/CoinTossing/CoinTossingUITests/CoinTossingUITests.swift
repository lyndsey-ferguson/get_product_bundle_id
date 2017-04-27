//
//  CoinTossingUITests.swift
//  CoinTossingUITests
//
//  Created by Shashikant Jagtap on 13/01/2017.
//  Copyright © 2017 Shashikant Jagtap. All rights reserved.
//

import XCTest

class CoinTossingUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func tossResult() -> String {
        let app = XCUIApplication()
        app.buttons["TossButton"].tap()
        let optionalResult = app.textFields["TossResult"].value!
        let result = String(describing: optionalResult)
        return result
    }
    
    func testResultIsHeads() {
        
        XCTAssertEqual(tossResult(), "Heads")
        
    }
    
    func testResultIsTails() {
        XCTAssertEqual(tossResult(), "Tails")
    }
}
