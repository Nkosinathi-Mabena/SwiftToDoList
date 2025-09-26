//
//  WeatherViewModelling.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/09/24.
//

import Foundation

protocol WeatherViewModeling: ObservableObject {
    var currentWeather: Weather? { get }
    var forecast: [Forecast] { get }
    var hourlyForecast: [HourlyForecast] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var selectedView: ForecastViewType { get set }
    func loadWeather(lat: Double, lon: Double) async
}
