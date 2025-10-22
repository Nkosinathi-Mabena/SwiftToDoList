//
//  WeatherFormatters.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/26.
//

import Foundation

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}

func formattedTime(_ date: Date) -> String { // printing Dates as strings.
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

func hourLabel(for date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "ha"
    return formatter.string(from: date)
}

func dayLabel(for date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "E"
    return formatter.string(from: date)
}

var backgroundImageForTimeOfDay: String {
    let hour = Calendar.current.component(.hour, from: Date())
    
    switch hour {
    case 6..<12:
        return "sunrise"
    case 12..<18:
        return "afternoon"
    default:
        return "night"
    }
}
