//
//  ForecastResponse.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/20.
//

import Foundation

struct ForecastResponse: Codable {
    let location: Location
    let current: Current
    let forecast: ForecastDays
    
    struct Location: Codable {
        let name: String
    }
    
    struct Current: Codable {
        let tempC: Double
        let condition: Condition
        let lastUpdatedEpoch: TimeInterval
    }
    
    struct ForecastDays: Codable {
        let forecastday: [ForecastItem]
    }
    
    struct ForecastItem: Codable {
        let dateEpoch: TimeInterval
        let day: Day
        let astro: Astro
    }
    
    struct Day: Codable {
        let maxtempC: Double
        let mintempC: Double
        let avgtempC: Double
        let condition: Condition
    }
    
    struct Condition: Codable {
        let text: String
        let icon: String
    }
    
    struct Astro: Codable {
        let sunrise: String
        let sunset: String
    }
    
    func toForecast() -> [Forecast] {
        forecast.forecastday.map { item in
            let isToday = Calendar.current.isDate(
                Date(timeIntervalSince1970: item.dateEpoch),
                inSameDayAs: Date()
            )
            
            return Forecast(
                temperature: isToday ? current.tempC : item.day.avgtempC,
                description: item.day.condition.text,
                date: Date(timeIntervalSince1970: item.dateEpoch),
                sunrise: parseTime(item.astro.sunrise),
                sunset: parseTime(item.astro.sunset),
                icon:isToday ? "https:\(current.condition.icon)": "https:\(item.day.condition.icon)"
            )
        }
    }
    
    func toWeather(for date: Date = Date()) -> Weather? {
        guard let today = forecast.forecastday.first(where: {
            Calendar.current.isDate(Date(timeIntervalSince1970: $0.dateEpoch), inSameDayAs: date)
        }) else {
            return nil
        }
        
        return Weather(
            location: location.name,
            temperature: current.tempC,
            description: current.condition.text,
            date: Date(timeIntervalSince1970: current.lastUpdatedEpoch),
            sunrise: parseTime(today.astro.sunrise),
            sunset: parseTime(today.astro.sunset),
            icon: "https:\(current.condition.icon)"
        )
    }
    
    private func parseTime(_ time: String) -> Date { //reading strings into Dates
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // this will ensure the formatter works consistently regardless of the users device region or language setting
        
        let formats = ["hh:mm a", "HH:mm"] // two formats 06:45 AM or 18:45
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: time) {
                return date
            }
        }
        
        return Date(timeIntervalSince1970: 0) //else returns first of jan 1970 so it easier to detect when debugging
    }

}


