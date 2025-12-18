//
//  WeatherFormattersTests.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/11/21.
//

import XCTest
@testable import SwiftToDoList

final class WeatherFormattersTests: XCTestCase {
    func testFormattedDate() {
            let calendar = Calendar(identifier: .gregorian)
            let date = calendar.date(from: DateComponents(year: 2025, month: 11, day: 21))!
            let result = formattedDate(date)
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
        formatter.locale = Locale.current
            let expected = formatter.string(from: date)
            
            XCTAssertEqual(result, expected)
        }

        func testFormattedTime() {
            let calendar = Calendar(identifier: .gregorian)
            let date = calendar.date(from: DateComponents(year: 2025, month: 11, day: 21, hour: 14, minute: 30))!
            let result = formattedTime(date)
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .none
            formatter.locale = Locale.current
            let expected = formatter.string(from: date)
            
            XCTAssertEqual(result, expected)
        }

        func testHourLabel() {
            let calendar = Calendar(identifier: .gregorian)
            let date = calendar.date(from: DateComponents(year: 2025, month: 11, day: 21, hour: 15))!
            let result = hourLabel(for: date)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "ha"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            let expected = formatter.string(from: date)
            
            XCTAssertEqual(result, expected)
        }

        func testDayLabel() {
            let calendar = Calendar(identifier: .gregorian)
            let date = calendar.date(from: DateComponents(year: 2025, month: 11, day: 21))! // Friday
            let result = dayLabel(for: date)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            let expected = formatter.string(from: date)
            
            XCTAssertEqual(result, expected)
        }
}
