//
//  WeatherResponse.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/20.
//

//import Foundation
//
//struct WeatherResponse: Codable {
//    let location: Location
//    let current: Current
//    
//    struct Location: Codable {
//        let name: String
//        let localtime_epoch: TimeInterval
//    }
//    
//    struct Current: Codable {
//        let temp_c: Double
//        let condition: Condition
//        let sunrise: String?
//        let sunset: String?
//    }
//    
//    struct Condition: Codable {
//        let text: String
//        let icon: String
//    }
//    
//    func toDomain() -> Weather {
//        Weather(
//            location: location.name,
//            temperature: current.temp_c,
//            description: current.condition.text,
//            date: Date(timeIntervalSince1970: location.localtime_epoch),
//            sunrise: parseTime(current.sunrise),
//            sunset: parseTime(current.sunset),
//            icon:current.condition.icon
//        )
//    }
//    
//    private func parseTime(_ time: String?) -> Date { //Convert
//        guard let time = time else { return Date() }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "hh:mm a"
//        return formatter.date(from: time) ?? Date()
//    }
//}
