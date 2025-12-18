//
//  WeatherRepositoryTest.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/11/19.
//

import XCTest
import Foundation
@testable import SwiftToDoList

final class WeatherRepositoryTest: XCTestCase {
    var weatherRepository: WeatherRepositoryProtocol!
    
    override func setUp() {
        super.setUp()
        weatherRepository = WeatherRepository()
    }
    
    override func tearDown() {
        weatherRepository = nil
        super.tearDown()
    }
    
    func testFetchWeather() async throws {
        //coordinates of Johannesburg Florida
        let lat = -26.2023
        let lon = 28.0436
        
        do {
            let (weather, forecast, hourly) = try await weatherRepository.fetchWeather(lat: lat, lon: lon)
            
            XCTAssertNotNil(weather)
            XCTAssertFalse(forecast.isEmpty, "Forecast array should not be empty")
            XCTAssertFalse(hourly.isEmpty, "Hourly forecast array should not be empty")
            
            print("Weather: \(weather)")
            print("Forecast days: \(forecast)")
            print("Hourly forecast: \(hourly)")
        } catch {
            XCTFail("Failed to fetch weather: \(error)")
        }
    }
}



