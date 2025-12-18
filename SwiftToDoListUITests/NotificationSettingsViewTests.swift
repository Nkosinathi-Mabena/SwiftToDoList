//
//  NotificationSettingsViewTests.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/12/10.
//

import XCTest
@testable import SwiftToDoList

final class NotificationSettingsUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }
    
    func test_openSettingsTab(app: XCUIApplication) {
        let settingsTab = app.tabBars.buttons["Settings"]
        XCTAssertTrue(settingsTab.waitForExistence(timeout: 3), "Settings tab should exist")
        settingsTab.tap()
    }
    
    func testDailyReminderToggle() throws {
        test_openSettingsTab(app: app)
        
        let dailyToggle = app.toggles["Daily Task Reminder"]
        XCTAssertTrue(dailyToggle.waitForExistence(timeout: 3), "Daily Task Reminder toggle should exist")
        
        if dailyToggle.value as! String == "0" {
            dailyToggle.tap()
        }
        XCTAssertEqual(dailyToggle.value as! String, "1", "Toggle should be ON after tapping")
        
        if dailyToggle.value as! String == "1" {
            dailyToggle.tap()
        }
        XCTAssertEqual(dailyToggle.value as! String, "0", "Toggle should be OFF after tapping")
    }
    
    func test_TasksWithRemindersAreVisible() throws {
        test_openSettingsTab(app: app)
        
        let taskCell = app.staticTexts["Test Task"]
        XCTAssertTrue(taskCell.waitForExistence(timeout: 3), "Task with reminder should be visible")
    }
}
