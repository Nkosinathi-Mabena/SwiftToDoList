//
//  ToDoViewTest.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/11/28.
//

import XCTest
@testable import SwiftToDoList

final class ToDoViewTest: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
    }
    
    func test_SegmentedTypes() {
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["All Task"].tap()
        
        XCTAssertTrue(app.buttons["Incompleted"].exists)
        XCTAssertTrue(app.buttons["Completed"].exists)
        
        app.staticTexts["Priority"].tap()
        
        XCTAssertTrue(app.buttons["Low"].exists)
        XCTAssertTrue(app.buttons["Medium"].exists)
        XCTAssertTrue(app.buttons["High"].exists)
        
        app.staticTexts["Today"].tap()
        
        XCTAssertTrue(app.buttons["Today's Tasks"].exists)
        
        app.staticTexts["Over Due"].tap()
        
        XCTAssertTrue(app.buttons["Over Due"].exists)
        
    }
}
