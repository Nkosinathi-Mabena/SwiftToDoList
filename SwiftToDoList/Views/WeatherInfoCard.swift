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
    var highTemp: String
    var lowTemp: String
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 5) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 30))
                
                Text(location)
                    .font(.custom("TrebuchetMS", size: 40))
                    .font(.title)
                    .bold()

                Text(date)
                    .font(.custom("TrebuchetMS", size: 20))
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
//            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
//            .overlay(
//                RoundedRectangle(cornerRadius: 20, style: .continuous)
//                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
//            )
//            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 6)
            
            VStack(spacing: 10){
                AsyncImage(url: URL(string: icon)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: UIScreen.main.bounds.height * 0.2)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: UIScreen.main.bounds.height * 0.12)
                    case .failure:
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: UIScreen.main.bounds.height * 0.2)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Text(temperature)
                    .font(.custom("TrebuchetMS", size: 45))
                    .bold()
                
                Text(description)
                    .font(.custom("TrebuchetMS", size: 20))
                    .font(.title2)
                
                // High/Low Temperature Row
                HStack(spacing: 30) {
                    VStack(spacing: 5) {
                        Text("High")
                            .font(.custom("TrebuchetMS", size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text(highTemp)
                            .font(.custom("TrebuchetMS", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    
                    VStack(spacing: 5) {
                        Text("Low")
                            .font(.custom("TrebuchetMS", size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text(lowTemp)
                            .font(.custom("TrebuchetMS", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 6)
            
            VStack(spacing: 10) {
                HStack(spacing: 20) {
                    // Sunrise
                    VStack(spacing: 5) {
                        Image(systemName: "sunrise.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.orange)
                        
                        Text("Sunrise")
                            .font(.custom("TrebuchetMS", size: 16))
                            .fontWeight(.medium)
                        
                        Text(sunrise)
                            .font(.custom("TrebuchetMS", size: 18))
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 6)
                    
                    // Sunset
                    VStack(spacing: 5) {
                        Image(systemName: "sunset.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.purple)
                        
                        Text("Sunset")
                            .font(.custom("TrebuchetMS", size: 16))
                            .fontWeight(.medium)
                        
                        Text(sunset)
                            .font(.custom("TrebuchetMS", size: 18))
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 6)
                }
            }
            
        }
    }
}

#Preview{
    WeatherInfoCard(
        location: "Johannesburg",
        icon: "https://cdn.weatherapi.com/weather/64x64/day/116.png" ,
        temperature: "22°C",
        description: "Partly Cloudly",
        date: "18 Sep 2025",
        sunrise: "05:30",
        sunset: "17:43",
        highTemp: "28°C",
        lowTemp: "16°C"
    )
}

