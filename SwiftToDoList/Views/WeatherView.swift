//
//  WeatherView.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/12.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel(repository: WeatherRepository(),locationManager: LocationManager())
    
    var body: some View {
        VStack(spacing: 20) {
            if let weather = viewModel.currentWeather {
                WeatherInfoCard(
                    location: weather.location,
                    icon: weather.icon.systemName,
                    temperature: "\(Int(weather.temperature))°C",
                    description: weather.description,
                    date: formattedDate(weather.date),
                    sunrise: formattedTime(weather.sunrise),
                    sunset: formattedTime(weather.sunset)
                )
            } else if viewModel.isLoading {
                ProgressView("Loading weather...")
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                Text("No weather data available")
            }

            ForecastCardRow(forecasts: viewModel.forecast)
                .padding(.bottom, 32) // push it above tab bar
        }
        .padding(.horizontal)
        .ignoresSafeArea(.keyboard, edges: .bottom) // still respect tab bar
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
            WeatherView()
    }
}
