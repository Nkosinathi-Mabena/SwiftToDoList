//
//  WeatherIconMapper.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/26.
//

import Foundation

enum WeatherIcon: String {
    case sunny = "sun.max.fill"
    case partlyCloudy = "cloud.sun.fill"
    case cloudy = "cloud.fill"
    case rain = "cloud.rain.fill"
    case thunderstorm = "cloud.bolt.rain.fill"
    case snow = "snow"
    case fog = "cloud.fog.fill"
    case unknown = "questionmark.circle"
    
    var systemName: String {
        return self.rawValue
    }
}

struct WeatherIconMapper {
    static func mapIcon(from urlString: String) -> WeatherIcon {
        guard let code = urlString
            .split(separator: "/")
            .last?
            .replacingOccurrences(of: ".png", with: "")
        else { return .unknown }
        
        switch code {
        case "113": return .sunny
        case "116": return .partlyCloudy
        case "119": return .cloudy
        case "122": return .cloudy
        case "143": return .fog
        case "176", "296", "353": return .rain
        case "389": return .thunderstorm
        case "179", "338", "368": return .snow
        default: return .unknown
        }
    }
}

