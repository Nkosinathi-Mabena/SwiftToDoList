//
//  WeatherInfoCard.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/12.
//

import SwiftUI

struct WeatherInfoCard: View {
    var location: String
    var icon: String
    var temperature: String
    var description: String
    var date: String
    var sunrise: String
    var sunset: String
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 5) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 30))
                
                Text(location)
                    .font(.title)
                    .bold()
                
                Text(date)
                    .font(.subheadline)
                    .bold()
            }
            .padding()
            
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(height: UIScreen.main.bounds.height * 0.2)
            
            Text(temperature)
                .font(.system(size: 50))
                .bold()
            
            Text(description)
                .font(.title2)
            
            HStack(spacing: 60) {
                Text("Sunrise: ") + Text(sunrise).bold()
                Text("Sunset: ") + Text(sunset).bold()
            }
        }
    }
}


