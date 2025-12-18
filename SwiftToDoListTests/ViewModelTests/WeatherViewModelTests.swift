//
//  WeatherViewModelTests.swift
//  SwiftToDoList
//
//  Created by Thokozani Mncube on 2025/11/21.
//

import XCTest
import Swinject

@testable import SwiftToDoList
import _LocationEssentials

final class WeatherViewModelTests: XCTestCase {
    private var container: Container!
    
    override func setUp() {
        super.setUp()
        container = Container()
    }
    
    override func tearDown() {
        container = nil
        super.tearDown()
    }
    
    func test_initialWeatherViewModelState() {
        container.register(WeatherRepositoryProtocol.self) { _ in
            return MockWeatherRepository()
        }
        
        container.register(LocationManager.self) { _ in
            return MockLocationManager()
        }
        container.register((any WeatherViewModeling).self) { resolver in
            return WeatherViewModel(repository: resolver.resolve(WeatherRepositoryProtocol.self)!, locationManager: resolver.resolve(LocationManager.self)!)
        }
        let viewModel = container.resolve((any WeatherViewModeling).self)
        
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel?.forecast.isEmpty ?? false)
        XCTAssertFalse(viewModel?.isLoading ?? true)
        XCTAssertNil(viewModel?.errorMessage)
    }
    
    func test_loadWeather() async throws {
        container.register(WeatherRepositoryProtocol.self) { _ in
            return MockWeatherRepository()
        }
        
        container.register(LocationManager.self) { _ in
            return MockLocationManager()
        }
        container.register((any WeatherViewModeling).self) { resolver in
            return WeatherViewModel(repository: resolver.resolve(WeatherRepositoryProtocol.self)!, locationManager: resolver.resolve(LocationManager.self)!)
        }
        let viewModel = container.resolve((any WeatherViewModeling).self)
        
        XCTAssertNil(viewModel?.currentWeather)
        XCTAssertTrue(viewModel?.hourlyForecast.isEmpty ?? false)
        XCTAssertFalse(viewModel?.isLoading ?? true)
        
        await viewModel?.loadWeather(lat: -26.2023, lon: 28.0436)
        
        XCTAssertNotNil(viewModel?.currentWeather)
        XCTAssertFalse(viewModel?.forecast.isEmpty ?? true)
        XCTAssertFalse(viewModel?.hourlyForecast.isEmpty ?? true)
        XCTAssertNil(viewModel?.errorMessage)
        XCTAssertFalse(viewModel?.isLoading ?? true)
    }
    
    func test_loadWeatherHandlesError() async throws {
        container.register(WeatherRepositoryProtocol.self) { _ in
            FailingWeatherRepository()
        }
        container.register(LocationManager.self) { _ in
            MockLocationManager()
        }
        container.register((any WeatherViewModeling).self) { resolver in
            WeatherViewModel(repository: resolver.resolve(WeatherRepositoryProtocol.self)!,
                             locationManager: resolver.resolve(LocationManager.self)!)
        }
        
        let viewModel = container.resolve((any WeatherViewModeling).self)!
        
        await viewModel.loadWeather(lat: -26.2023, lon: 28.0436)
        
        XCTAssertNil(viewModel.currentWeather)
        XCTAssertTrue(viewModel.forecast.isEmpty)
        XCTAssertTrue(viewModel.hourlyForecast.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    func test_locationUpdateTriggersLoadWeather() async throws {
        let mockLocationManager = MockLocationManager()
        
        container.register(WeatherRepositoryProtocol.self) { _ in
            MockWeatherRepository()
        }
        container.register(LocationManager.self) { _ in
            mockLocationManager
        }
        container.register((any WeatherViewModeling).self) { resolver in
            WeatherViewModel(repository: resolver.resolve(WeatherRepositoryProtocol.self)!,
                             locationManager: resolver.resolve(LocationManager.self)!)
        }
        
        let viewModel = container.resolve((any WeatherViewModeling).self)!
        
        mockLocationManager.sendMockLocation(lat: -26.2023, lon: 28.0436)
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertNotNil(viewModel.currentWeather)
        XCTAssertFalse(viewModel.forecast.isEmpty)
    }
    
}

private class MockWeatherRepository: WeatherRepositoryProtocol {
    func fetchWeather(lat: Double, lon: Double) async throws -> (SwiftToDoList.Weather, [SwiftToDoList.Forecast], [SwiftToDoList.HourlyForecast]) {
        let mock = MockWeatherViewModel()
        guard let currentWeather = mock.currentWeather
        else {
            throw MockErrors.repositoryError
        }
        return (currentWeather, mock.forecast, mock.hourlyForecast)
    }
}

private enum MockErrors: Error {
    case repositoryError
}

private class FailingWeatherRepository: WeatherRepositoryProtocol {
    func fetchWeather(lat: Double, lon: Double) async throws -> (Weather, [Forecast], [HourlyForecast]) {
        throw MockErrors.repositoryError
    }
}

private class MockLocationManager: LocationManager {
    override init() {
        super.init()
    }
    
    func sendMockLocation(lat: Double, lon: Double) {
        let location = CLLocation(latitude: lat, longitude: lon)
        self.lastLocation = location
    }
}
