//
//  WeatherResponseTest.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/11/19.
//

import XCTest
@testable import SwiftToDoList

final class WeatherResponseTest: XCTestCase {
    func test_toWeather() {
        let mock = WeatherResponseMock.mockData()
        let weather = mock.toWeather()
        
        XCTAssertNotNil(weather)
        XCTAssertEqual(weather?.location, "Johannesburg")
        XCTAssertEqual(weather?.temperature, 22.5)
        XCTAssertEqual(weather?.description, "Partly Cloudy")
        
        let futureDate = Date().addingTimeInterval(60 * 60 * 24 * 2)
        let futureWeather = mock.toWeather(for: futureDate)
        
        XCTAssertNil(futureWeather)
    }
}

private class WeatherResponseMock {
    static func mockData() -> ForecastResponse {
        let today = Calendar.current.startOfDay(for: Date())
        let dateEpoch = today.timeIntervalSince1970
        
        let forecastItem = ForecastResponse.ForecastItem(
            dateEpoch: dateEpoch,
            day: ForecastResponse.Day(
                maxtempC: 30.0,
                mintempC: 20.0,
                avgtempC: 25.0,
                condition: ForecastResponse.Condition(
                    text: "Sunny",
                    icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
                )
            ),
            astro: ForecastResponse.Astro(
                sunrise: "06:00 AM",
                sunset: "18:00 PM"
            ),
            hour: []
        )
        
        return ForecastResponse(
            location: ForecastResponse.Location(name: "Johannesburg"),
            current: ForecastResponse.Current(
                tempC: 22.5,
                condition: ForecastResponse.Condition(
                    text: "Partly Cloudy",
                    icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
                ),
                lastUpdatedEpoch: today.addingTimeInterval(3600).timeIntervalSince1970
            ),
            forecast: ForecastResponse.ForecastDays(
                forecastday: [forecastItem]
            )
        )
    }
}

