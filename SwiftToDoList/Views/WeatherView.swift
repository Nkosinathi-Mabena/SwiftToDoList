//
//  WeatherView.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/12.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel : WeatherViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: DIContainer.shared.resolveWeatherViewModel())
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.53, green: 0.61, blue: 0.98),
                    Color(red: 0.35, green: 0.71, blue: 0.95)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                if let weather = viewModel.currentWeather {
                    WeatherInfoCard(
                        location: weather.location,
                        icon: weather.icon,
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
                
                Picker("View Type", selection: $viewModel.selectedView){
                    ForEach(ForecastViewType.allCases, id: \.self){ type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                switch viewModel.selectedView{
                case .daily:
                    ForecastCardRow(forecasts: viewModel.forecast)
                        .padding(.bottom,12)
                case .hourly:
                    HourlyForecastCardRow(hourlyForecast: viewModel.hourlyForecast)
                        .padding(.bottom,12)
                }
            }
            .padding(.top,70)
            .padding(.horizontal)
        }
        
    }
}


struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
            WeatherView()
    }
}
