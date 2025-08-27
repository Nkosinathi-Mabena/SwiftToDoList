//
//  WeatherViewModel.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/21.
//

import Foundation

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var currentWeather: Weather?
    @Published var forecast: [Forecast] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private let repository: WeatherRepositoryProtocol
    
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadWeather(lat: Double, lon: Double) async {
        print("📡 Loading weather for lat: \(lat), lon: \(lon)")
        
        isLoading = true
        errorMessage = nil
        do {
            let (currentResult, forecastResult) = try await repository.fetchWeather(lat: lat, lon: lon)

            self.currentWeather = currentResult
            self.forecast = forecastResult
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

