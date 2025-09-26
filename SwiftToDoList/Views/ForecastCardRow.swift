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
                        .font(.custom("TrebuchetMS", size: 18))
                        .bold()
                    
                    Text("\(Int(forecast.temperature))°C")
                        .font(.custom("TrebuchetMS", size: 16))
                        .bold()
                    
                    ForecastIconView(iconURL: forecast.icon)

                }
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .cornerRadius(20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 6)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}


struct ForecastCardRow_Previews: PreviewProvider {
    static var previews: some View {
        let mockForecasts = [
            Forecast(temperature: 23,description: "Sunny",date: Date(),sunrise: Date(),sunset: Date(),icon:"https://cdn.weatherapi.com/weather/64x64/day/116.png"
            ),
            Forecast(temperature: 21,description: "Cloudy",date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,sunrise: Date(),sunset:Date(),icon:"https://cdn.weatherapi.com/weather/64x64/day/119.png"
            ),
            Forecast(temperature: 19,description: "Rainy",date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,sunrise: Date(),sunset:Date(),icon:"https://cdn.weatherapi.com/weather/64x64/day/113.png"
            )
        ]
        
        ForecastCardRow(forecasts: mockForecasts)
            .previewLayout(.sizeThatFits)
    }
}
