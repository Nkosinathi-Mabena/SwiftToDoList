//
//  LocationManagerTest.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/11/18.
//

import XCTest
import CoreLocation
@testable import SwiftToDoList

final class LocationManagerTest: XCTestCase {
    func testLocationManager() {
        let locationManager = MockLocationManagers()
        
        locationManager.sendMockLocation(lat: 12.34, lon: 56.78)
        
        XCTAssertEqual(locationManager.lastLocation?.coordinate.latitude, 12.34)
        XCTAssertEqual(locationManager.lastLocation?.coordinate.longitude, 56.78)
    }
    
    func testLocationManager_ignoresEmptyUpdate() {
        let manager = MockLocationManagers()
        manager.locationManager(CLLocationManager(), didUpdateLocations: [])
        XCTAssertNil(manager.lastLocation)
    }
    
    func testLocationManager_overwritesWithLatestLocation() {
        let manager = MockLocationManagers()
        manager.sendMockLocation(lat: 1.0, lon: 1.0)
        manager.sendMockLocation(lat: 2.0, lon: 3.0)
        XCTAssertEqual(manager.lastLocation?.coordinate.latitude, 2.0)
        XCTAssertEqual(manager.lastLocation?.coordinate.longitude, 3.0)
    }
}
class MockLocationManagers: LocationManager {
    override init() {
        super.init()
    }
    
    func sendMockLocation(lat: Double, lon: Double) {
        let location = CLLocation(latitude: lat, longitude: lon)
        self.locationManager(CLLocationManager(), didUpdateLocations: [location])
    }
}
