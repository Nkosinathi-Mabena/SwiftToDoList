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
    
    

    
    private func parseTime(_ time: String) -> Date {
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


