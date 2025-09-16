//
//  ForecastCardView.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/12.
//

import SwiftUI

struct ForecastCardRow: View {
    let forecasts: [Forecast]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(Array(forecasts.prefix(3).enumerated()), id: \.1.id) { _, forecast in
                VStack(spacing: 10) {
                    Text(dayLabel(for: forecast.date))
                        .bold()
                    
                    Text("\(Int(forecast.temperature))°C")
                        .bold()
                    
                    ForecastIconView(iconURL: forecast.icon)

                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
                .background(Color(.systemGray6).opacity(0.4))
                .cornerRadius(20)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}

struct ForecastIconView: View {
    let iconURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: iconURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(height: 30)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            case .failure:
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            @unknown default:
                EmptyView()
            }
        }
    }
}

struct ForecastCardRow_Previews: PreviewProvider {
    static var previews: some View {
        let mockForecasts = [
            Forecast(temperature: 23,description: "Sunny",date: Date(),sunrise: Date(),sunset: Date(),icon:"https://cdn.weatherapi.com/weather/64x64/day/116.png"
            ),
            Forecast(temperature: 21,description: "Cloudy",date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,sunrise: Date(),sunset:Date(),icon:"https://cdn.weatherapi.com/weather/64x64/day/119.png"
            ),
            Forecast(temperature: 19,description: "Rainy",date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,sunrise: Date(),sunset:Date(),icon:"https://cdn.weatherapi.com/weather/64x64/day/143.png"
            )
        ]
        
        ForecastCardRow(forecasts: mockForecasts)
            .previewLayout(.sizeThatFits)
    }
}
