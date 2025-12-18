//
//  HourlyForecastTest.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/11/19.
//

import XCTest
@testable import SwiftToDoList

final class HourlyForecastTest: XCTestCase {
    func test_toHourly() {
        let mock = HourlyForecastResponseMock.mockData()
        let hourlyForecast = mock.toHourlyForecast()
        
        XCTAssertNotNil(hourlyForecast)
        XCTAssertEqual(hourlyForecast[0].temperature, 20.0)
        XCTAssertEqual(hourlyForecast[1].temperature, 21.0)
        XCTAssertEqual(hourlyForecast[2].temperature, 22.0)
        XCTAssertEqual(hourlyForecast[0].description, "Sunny")
        
        let futureDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())!
        let hourly = mock.toHourlyForecast(for: futureDate)
        
        XCTAssertTrue(hourly.isEmpty)
    }
}

private class HourlyForecastResponseMock {
    static func mockData() -> ForecastResponse {
        let today = Calendar.current.startOfDay(for: Date())
        let dateEpoch = today.timeIntervalSince1970
        
        let hourly = (0..<3).map { hour in
            ForecastResponse.Hourly(
                timeEpoch: today.addingTimeInterval(Double(hour) * 3600).timeIntervalSince1970,
                tempC: 20.0 + Double(hour),
                condition: ForecastResponse.Condition(
                    text: "Sunny",
                    icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
                )
            )
        }
        
        let forecastItem = ForecastResponse.ForecastItem(
            dateEpoch: dateEpoch,
            day: ForecastResponse.Day(
                maxtempC: 25,
                mintempC: 15,
                avgtempC: 20,
                condition: ForecastResponse.Condition(text: "Sunny", icon: "//cdn.weatherapi.com/weather/64x64/day/113.png")
            ),
            astro: ForecastResponse.Astro(sunrise: "06:00 AM", sunset: "06:00 PM"),
            hour: hourly
        )
        
        return ForecastResponse(
            location: ForecastResponse.Location(name: "Johannesburg"),
            current: ForecastResponse.Current(
                tempC: 22,
                condition: ForecastResponse.Condition(
                    text: "Partly Cloudy",
                    icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
                ),
                lastUpdatedEpoch: today.timeIntervalSince1970
            ),
            forecast: ForecastResponse.ForecastDays(forecastday: [forecastItem])
        )
    }
}
