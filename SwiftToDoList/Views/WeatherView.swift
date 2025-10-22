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
            Image(backgroundImageForTimeOfDay)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.6)
            
            ScrollView {
                VStack(spacing: 5) {
                    if let weather = viewModel.currentWeather {
                        VStack(spacing: 20) {
                            WeatherInfoCard(
                                location: weather.location,
                                icon: weather.icon,
                                temperature: "\(Int(weather.temperature))°C",
                                description: weather.description,
                                date: formattedDate(weather.date),
                                sunrise: formattedTime(weather.sunrise),
                                sunset: formattedTime(weather.sunset),
                                highTemp: "\(Int(weather.highTemp))°C",
                                lowTemp: "\(Int(weather.lowTemp))°C"
                            )
                        }
                        .padding()
                      
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
                .padding(.top, 1)
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .ignoresSafeArea(.container, edges: .bottom) 
        }
    }
}


struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: DIContainer.shared.resolveMockWeatherViewModel() as! MockWeatherViewModel)
    }
}

