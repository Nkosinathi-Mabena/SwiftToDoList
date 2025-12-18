//
//  WeatherIconMapperTest.swift
//  SwiftToDoListTests
//
//  Created by Thokozani Mncube on 2025/12/08.
//

import XCTest
@testable import SwiftToDoList

final class WeatherIconMapperTests: XCTestCase {
    func test_knownCodes_mapToExpectedIcons() {
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../113.png"), .sunny)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../116.png"), .partlyCloudy)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../119.png"), .cloudy)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../122.png"), .cloudy)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../143.png"), .fog)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../176.png"), .rain)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../296.png"), .rain)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../353.png"), .rain)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../389.png"), .thunderstorm)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../179.png"), .snow)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../338.png"), .snow)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../368.png"), .snow)
    }
    
    func test_unknownOrMalformedIcons_returnUnknown() {
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "//.../999.png"), .unknown)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: "bad-format"), .unknown)
        XCTAssertEqual(WeatherIconMapper.mapIcon(from: ""), .unknown)
    }
}

