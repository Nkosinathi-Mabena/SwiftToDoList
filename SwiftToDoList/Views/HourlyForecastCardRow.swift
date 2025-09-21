//
//  HourlyForecastCardRow.swift
//  SwiftToDoList
//
//  Created by Nathi Mabena on 2025/09/20.
//

import SwiftUI


struct HourlyForecastCardRow: View {
    let hourlyForecast: [HourlyForecast]
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 10){
                ForEach(hourlyForecast, id: \.time){forecast in
                    VStack(spacing:10){
                        Text(hourLabel(for: forecast.time))
                            .font(.custom("TrebuchetMS", size: 16))
                            .bold()
                        
                        ForecastIconView(iconURL: forecast.icon)
                        
                        Text("\(Int(forecast.temperature))°C")
                            .font(.custom("TrebuchetMS", size: 16))
                            .bold()
                    }
                    .padding(.horizontal,20)
                    .padding(.vertical,15)
                    .background(Color(.systemGray6).opacity(0.4))
                    .cornerRadius(20)
                }
            }
            .padding(.horizontal)
            .padding(.top,10)
            
        }
    }

}

#Preview {
    
    let mockHourly = (0..<6).map{ offset in
        HourlyForecast(
            temperature: Double(18 + offset), description: "Clear", time: Calendar.current.date(byAdding: .hour, value: offset, to:Date())!, icon: "https://cdn.weatherapi.com/weather/64x64/day/116.png"
        )
    }
    
    HourlyForecastCardRow(hourlyForecast: mockHourly)
    
}
