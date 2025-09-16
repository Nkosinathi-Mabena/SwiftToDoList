//
//  WeatherViewModel.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/21.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var currentWeather: Weather?
    @Published var forecast: [Forecast] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

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

