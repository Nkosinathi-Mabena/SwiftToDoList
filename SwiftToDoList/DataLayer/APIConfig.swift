//
//  APIConfig.swift
//  ToDoList
//
//  Created by Nathi Mabena on 2025/08/20.
//

import Foundation

struct APIConfig {
    static var apiKey: String {
        guard let key = ProcessInfo.processInfo.environment["WEATHER_API_KEY"] else {
            fatalError("API key is not set in environment variables")
        }
        return key
    }
}
