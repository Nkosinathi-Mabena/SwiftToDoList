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



