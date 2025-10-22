//
//  MockWeatherViewModel.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/09/24.
//

import Foundation
import Combine

class MockWeatherViewModel: WeatherViewModeling {
    @Published var currentWeather: Weather?
    @Published var forecast: [Forecast] = []
    @Published var hourlyForecast: [HourlyForecast] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedView: ForecastViewType = .daily
    
    init() {
        setupMockData()
    }
    
    private func setupMockData() {
        currentWeather = Weather(
            location: "Cape Town",
            temperature: 22.0,
            description: "Partly cloudy",
            date: Date(),
            sunrise: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date()) ?? Date(),
            sunset: Calendar.current.date(bySettingHour: 18, minute: 45, second: 0, of: Date()) ?? Date(),
            icon: "https://cdn.weatherapi.com/weather/64x64/day/116.png",
            highTemp: 28.0,
            lowTemp: 16.0
        )
        
        let calendar = Calendar.current
        forecast = (0..<3).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: dayOffset, to: Date()) ?? Date()
            return Forecast(
                temperature: Double.random(in: 18...28),
                description: ["Sunny", "Partly cloudy", "Overcast", "Light rain"].randomElement() ?? "Sunny",
                date: date,
                sunrise: calendar.date(bySettingHour: 6, minute: 30, second: 0, of: date) ?? date,
                sunset: calendar.date(bySettingHour: 18, minute: 45, second: 0, of: date) ?? date,
                icon: "https://cdn.weatherapi.com/weather/64x64/day/116.png"
            )
        }
        
        hourlyForecast = (0..<24).map { hourOffset in
            let time = calendar.date(byAdding: .hour, value: hourOffset, to: Date()) ?? Date()
            return HourlyForecast(
                temperature: Double.random(in: 15...30),
                description: ["Clear", "Partly cloudy", "Cloudy"].randomElement() ?? "Clear",
                time: time,
                icon: "https://cdn.weatherapi.com/weather/64x64/night/113.png"
            )
        }
    }
    
    func loadWeather(lat: Double, lon: Double) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        await MainActor.run {
            if let old = currentWeather {
                currentWeather = Weather(
                    location: old.location,
                    temperature: Double.random(in: 18...28),
                    description: old.description,
                    date: old.date,
                    sunrise: old.sunrise,
                    sunset: old.sunset,
                    icon: old.icon,
                    highTemp: Double.random(in: 25...32),
                    lowTemp: Double.random(in: 12...20)
                )
            }
            isLoading = false
        }
    }
}
