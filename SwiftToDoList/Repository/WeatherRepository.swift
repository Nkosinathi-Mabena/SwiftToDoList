//
//  WeatherRepository.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/20.
//

import Foundation
import CoreLocation

protocol WeatherRepositoryProtocol {
    func fetchWeather(lat: Double, lon: Double) async throws -> (Weather, [Forecast])
}

final class WeatherRepository: WeatherRepositoryProtocol {
    
    private let baseURLString = "https://api.weatherapi.com/v1"
    
    func fetchWeather(lat: Double, lon: Double) async throws -> (Weather, [Forecast]) {
        let urlString = "\(baseURLString)/forecast.json?key=\(APIConfig.apiKey)&q=\(lat),\(lon)&days=3&aqi=no&alerts=no"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("RAW Forecast JSON: \(jsonString)")
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoded = try decoder.decode(ForecastResponse.self, from: data)
        
        // Convert into domain models
        guard let todayWeather = decoded.toWeather() else {
            throw URLError(.cannotParseResponse)
        }
        
        let forecastDays = decoded.toDomain()
        
        return (todayWeather, forecastDays)
    }
}
