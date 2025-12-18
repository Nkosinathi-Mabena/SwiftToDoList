//
//  ForecastResponseTest.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/11/21.
//

import XCTest
import Swinject
@testable import SwiftToDoList

final class ForecastResponseTest: XCTestCase {
    func test_toForecast() {
        let mock = ForecastResponseMock.make()
        let forecast = mock.toForecast()
        
        XCTAssertFalse(forecast.isEmpty)
        XCTAssertEqual(forecast.first?.description, "Sunny")
        XCTAssertEqual(forecast.count, 3)
        
        let todayForecast = forecast.first!
        let isToday = Calendar.current.isDate(todayForecast.date, inSameDayAs: Date())
        XCTAssertTrue(isToday)
        XCTAssertEqual(todayForecast.temperature, mock.current.tempC)
    }
    
    func test_toHourlyForecast() {
        let mock = ForecastResponseMock.make()
        let today = Calendar.current.startOfDay(for: Date())
        
        let hours = mock.toHourlyForecast(for: today)
        
        XCTAssertEqual(hours.count, 24)
        XCTAssertTrue(hours.allSatisfy { $0.icon.hasPrefix("https:") })
    }
    
    func test_toHourlyForecast_missingDateReturnsEmpty() {
        let mock = ForecastResponseMock.make()
        let missingDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
        
        let hours = mock.toHourlyForecast(for: missingDate)
        XCTAssertTrue(hours.isEmpty)
    }
    
    func test_toWeather_missingDateReturnsNil() {
        let mock = ForecastResponseMock.make()
        let missingDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
        
        let weather = mock.toWeather(for: missingDate)
        XCTAssertNil(weather)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

private class ForecastResponseMock {
    static func make() -> ForecastResponse {
        let today = Calendar.current.startOfDay(for: Date())

        func makeDay(offset: Int,
                     max: Double,
                     min: Double,
                     avg: Double,
                     conditionText: String,
                     conditionIcon: String) -> ForecastResponse.ForecastItem {

            let date = Calendar.current.date(byAdding: .day, value: offset, to: today)!

            return ForecastResponse.ForecastItem(
                dateEpoch: date.timeIntervalSince1970,
                day: ForecastResponse.Day(
                    maxtempC: max,
                    mintempC: min,
                    avgtempC: avg,
                    condition: ForecastResponse.Condition(
                        text: conditionText,
                        icon: conditionIcon
                    )
                ),
                astro: ForecastResponse.Astro(
                    sunrise: "06:10 AM",
                    sunset: "07:05 PM"
                ),
                hour: (0..<24).map { hour in
                    ForecastResponse.Hourly(
                        timeEpoch: date.addingTimeInterval(Double(hour) * 3600).timeIntervalSince1970,
                        tempC: Double.random(in: min...max),
                        condition: ForecastResponse.Condition(
                            text: "Clear",
                            icon: "//cdn.weatherapi.com/weather/64x64/night/113.png"
                        )
                    )
                }
            )
        }

        return ForecastResponse(
            location: ForecastResponse.Location(name: "Johannesburg"),
            current: ForecastResponse.Current(
                tempC: 22.5,
                condition: ForecastResponse.Condition(
                    text: "Partly Cloudy",
                    icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
                ),
                lastUpdatedEpoch: Date().timeIntervalSince1970
            ),
            forecast: ForecastResponse.ForecastDays(
                forecastday: [
                    makeDay(
                        offset: 0,
                        max: 28,
                        min: 15,
                        avg: 22,
                        conditionText: "Sunny",
                        conditionIcon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
                    ),
                    makeDay(
                        offset: 1,
                        max: 26,
                        min: 14,
                        avg: 20,
                        conditionText: "Cloudy",
                        conditionIcon: "//cdn.weatherapi.com/weather/64x64/day/119.png"
                    ),
                    makeDay(
                        offset: 2,
                        max: 24,
                        min: 13,
                        avg: 18,
                        conditionText: "Rain Showers",
                        conditionIcon: "//cdn.weatherapi.com/weather/64x64/day/176.png"
                    )
                ]
            )
        )
    }
 }

 /*
  
  private class ForecastResponseMock {
     
     static func makePartial() -> ForecastResponse {
         let today = Calendar.current.startOfDay(for: Date())
         
         func makeDay(offset: Int,
                      max: Double,
                      min: Double,
                      avg: Double,
                      conditionText: String,
                      conditionIcon: String) -> ForecastResponse.ForecastItem {
             
             let date = Calendar.current.date(byAdding: .day, value: offset, to: today)!
             return ForecastResponse.ForecastItem(
                 dateEpoch: date.timeIntervalSince1970,
                 day: ForecastResponse.Day(
                     maxtempC: max,
                     mintempC: min,
                     avgtempC: avg,
                     condition: ForecastResponse.Condition(
                         text: conditionText,
                         icon: conditionIcon
                     )
                 ),
                 astro: ForecastResponse.Astro(
                     sunrise: "06:10 AM",
                     sunset: "07:05 PM"
                 ),
                 hour: []
             )
         }
         
         return ForecastResponse(
             location: ForecastResponse.Location(name: "Johannesburg"),
             current: ForecastResponse.Current(
                 tempC: 22.5,
                 condition: ForecastResponse.Condition(
                     text: "Sunny",
                     icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
                 ),
                 lastUpdatedEpoch: Date().timeIntervalSince1970
             ),
             forecast: ForecastResponse.ForecastDays(
                 forecastday: [
                     makeDay(offset: 0, max: 28, min: 15, avg: 22,
                             conditionText: "Sunny",
                             conditionIcon: "//cdn.weatherapi.com/weather/64x64/day/113.png")
                 ]
             )
         )
     }
 }
 */
