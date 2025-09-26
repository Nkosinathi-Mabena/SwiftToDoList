//
//  WeatherView.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/12.
//

import SwiftUI

struct WeatherView<ViewModel: WeatherViewModeling & ObservableObject>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack(alignment: .leading) {
            Image("afternoon")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                if let weather = viewModel.currentWeather {
                    VStack(spacing: 20) {
                        WeatherInfoCard(
                            location: weather.location,
                            icon: weather.icon,
                            temperature: "\(Int(weather.temperature))°C",
                            description: weather.description,
                            date: formattedDate(weather.date),
                            sunrise: formattedTime(weather.sunrise),
                            sunset: formattedTime(weather.sunset)
                        )
                    }
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 6)
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
        WeatherView(viewModel: DIContainer.shared.resolveMockWeatherViewModel() as! MockWeatherViewModel)
    }
}

