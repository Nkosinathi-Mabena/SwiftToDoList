//
//  Weather.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/20.
//

import Foundation

struct Weather{
    let location: String
    let temperature: Double
    let description: String
    let date: Date
    let sunrise: Date
    let sunset: Date
    let icon: String
    let highTemp: Double
    let lowTemp: Double
}

struct Forecast: Identifiable {
    let id = UUID()
    let temperature: Double
    let description: String
    let date: Date
    let sunrise: Date
    let sunset: Date
    let icon: String
}

struct HourlyForecast {
    let temperature: Double
    let description: String
    let time: Date
    let icon: String
}



