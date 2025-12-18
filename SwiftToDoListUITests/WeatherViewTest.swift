//
//  WeatherViewTest.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/12/02.
//

import XCTest
@testable import SwiftToDoList

final class WeatherViewTest: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.terminate()  
        if let apiKey = ProcessInfo.processInfo.environment["WEATHER_API_KEY"] {
            app.launchEnvironment["WEATHER_API_KEY"] = apiKey
        }
        app.launch()
        
        handleLocationPermissionAlert()
    }

    private func handleLocationPermissionAlert() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

        let allowWhileUsing = springboard.alerts.buttons["Allow While Using App"]
        if allowWhileUsing.waitForExistence(timeout: 5) {
            allowWhileUsing.tap()
        }

        let allowOnce = springboard.alerts.buttons["Allow Once"]
        if allowOnce.waitForExistence(timeout: 2) {
            allowOnce.tap()
        }
    }

    private func openWeatherScreen() {
        let weatherButton = app.buttons["Weather"]
        XCTAssertTrue(weatherButton.waitForExistence(timeout: 5))
        weatherButton.tap()
    }
    
    @discardableResult
    private func segmentedControlEnsuringHittable() -> XCUIElement {
        let segmentedControl = app.segmentedControls.firstMatch
        XCTAssertTrue(segmentedControl.waitForExistence(timeout: 5))
        
        if !segmentedControl.isHittable {
            app.swipeUp()
        }
        return segmentedControl
    }

    func test_weatherScreenOpens() {
        openWeatherScreen()

        let segmentedControl = segmentedControlEnsuringHittable()
        XCTAssertTrue(segmentedControl.exists)
    }

    func test_segmentedControlExists() {
        openWeatherScreen()

        let segmentedControl = segmentedControlEnsuringHittable()
        XCTAssertTrue(segmentedControl.exists)
    }

    func test_loadingOrEmptyStateAppears() {
        openWeatherScreen()

        let loading = app.staticTexts["Loading weather..."]
        let noData = app.staticTexts["No weather data available"]
        let errorText = app.staticTexts.containing(NSPredicate(format: "label BEGINSWITH 'Error:'")).firstMatch

        let loadingExists = loading.waitForExistence(timeout: 10.0)
        let noDataExists = noData.waitForExistence(timeout: 0.1)
        let errorExists = errorText.waitForExistence(timeout: 0.1)

        XCTAssertTrue(loadingExists || noDataExists || errorExists,
                      "The screen should show loading, no data, or error state.")
    }
    
    func test_canTapDailyAndHourlySegments() {
        openWeatherScreen()
        
        let segmentedControl = segmentedControlEnsuringHittable()
        
        if segmentedControl.buttons["Hourly"].exists {
            segmentedControl.buttons["Hourly"].tap()
        }
        
        if segmentedControl.buttons["3-Day"].exists {
            segmentedControl.buttons["3-Day"].tap()
        }
    }
    
    func test_segmentedControl_becomesHittableAfterScroll() {
        openWeatherScreen()
        
        let segmentedControl = app.segmentedControls.firstMatch
        XCTAssertTrue(segmentedControl.waitForExistence(timeout: 5))
        
        if !segmentedControl.isHittable {
            app.swipeUp()
        }
        XCTAssertTrue(segmentedControl.isHittable)
    }
}
