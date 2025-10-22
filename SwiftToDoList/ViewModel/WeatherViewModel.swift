//
//  WeatherViewModel.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/21.
//

import Foundation
import Combine
import CoreLocation

enum ForecastViewType:String, CaseIterable{
    case daily = "3-Day"
    case hourly = "Hourly"
}

final class WeatherViewModel: WeatherViewModeling {
    @Published var currentWeather: Weather?
    @Published var forecast: [Forecast] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var hourlyForecast: [HourlyForecast] = [] //Array of HourlyForecast struct, starts empty, but when api makes call @Published variable will update ui with data
    @Published var selectedView: ForecastViewType = .daily

    private let repository: WeatherRepositoryProtocol
    private let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: WeatherRepositoryProtocol, locationManager: LocationManager) {
        self.repository = repository
        self.locationManager = locationManager
        bindLocationUpdates()
    }
    
    private func bindLocationUpdates() {
        locationManager.$lastLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                Task {
                    await self?.loadWeather(
                        lat: location.coordinate.latitude,
                        lon: location.coordinate.longitude
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    func loadWeather(lat: Double, lon: Double) async {
        print("📡 Loading weather for lat: \(lat), lon: \(lon)")
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let (currentResult, forecastResult, hourlyResult) = try await repository.fetchWeather(lat: lat, lon: lon)

            await MainActor.run {
                self.currentWeather = currentResult
                self.forecast = forecastResult
                self.hourlyForecast = hourlyResult
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
}

