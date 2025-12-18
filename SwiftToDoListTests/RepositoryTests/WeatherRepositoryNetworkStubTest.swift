//
//  WeatherRepositoryNetworkStubTest.swift
//  SwiftToDoListTests
//
//  Created by Thokozani Mncube on 2025/12/08.
//

import XCTest
import Foundation
@testable import SwiftToDoList

final class WeatherRepositoryNetworkStubTest: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    override class func tearDown() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
        super.tearDown()
    }
    
    override func tearDown() {
        URLProtocolStub.clear()
        super.tearDown()
    }
    
    func test_fetchWeather_happyPath_returnsModels() async throws {
        let repo: WeatherRepositoryProtocol = WeatherRepository()
        let todayEpoch = Date().timeIntervalSince1970
        URLProtocolStub.stubResponse(data: Self.makeForecastJSON(dateEpoch: todayEpoch), statusCode: 200)
        
        let (weather, forecast, hourly) = try await repo.fetchWeather(lat: 0, lon: 0)
        
        XCTAssertEqual(weather.location, "WhoVille")
        XCTAssertFalse(forecast.isEmpty)
        XCTAssertFalse(hourly.isEmpty)
    }
    
    func test_fetchWeather_invalidJSON_throws() async {
        let repo: WeatherRepositoryProtocol = WeatherRepository()
        URLProtocolStub.stubResponse(data: Data("not json".utf8), statusCode: 200)
        
        do {
            _ = try await repo.fetchWeather(lat: 0, lon: 0)
            XCTFail("Expected decode error")
        } catch {
        }
    }
    
    func test_fetchWeather_missingToday_throwsCannotParse() async {
        let repo: WeatherRepositoryProtocol = WeatherRepository()
        let futureEpoch = Date().addingTimeInterval(5 * 24 * 60 * 60).timeIntervalSince1970
        URLProtocolStub.stubResponse(data: Self.makeForecastJSON(dateEpoch: futureEpoch), statusCode: 200)
        
        do {
            _ = try await repo.fetchWeather(lat: 0, lon: 0)
            XCTFail("Expected cannotParseResponse")
        } catch {
            guard let urlError = error as? URLError else {
                XCTFail("Expected URLError"); return
            }
            XCTAssertEqual(urlError.code, .cannotParseResponse)
        }
    }
    
    private static func makeForecastJSON(dateEpoch: TimeInterval) -> Data {
        let json = """
        {
          "location": { "name": "WhoVille" },
          "current": {
            "temp_c": 20.5,
            "condition": { "text": "Sunny", "icon": "//cdn.weather/113.png" },
            "last_updated_epoch": 1700000000
          },
          "forecast": {
            "forecastday": [
              {
                "date_epoch": \(dateEpoch),
                "day": {
                  "maxtemp_c": 25.0,
                  "mintemp_c": 15.0,
                  "avgtemp_c": 20.0,
                  "condition": { "text": "Sunny", "icon": "//cdn.weather/113.png" }
                },
                "astro": { "sunrise": "06:00 AM", "sunset": "06:00 PM" },
                "hour": [
                  {
                    "time_epoch": \(dateEpoch),
                    "temp_c": 20.0,
                    "condition": { "text": "Sunny", "icon": "//cdn.weather/113.png" }
                  }
                ]
              }
            ]
          }
        }
        """
        return Data(json.utf8)
    }
}

final class URLProtocolStub: URLProtocol {
    private static var stubData: Data?
    private static var stubResponse: HTTPURLResponse?
    private static var stubError: Error?
    
    static func stubResponse(data: Data?, statusCode: Int = 200, error: Error? = nil) {
        self.stubData = data
        self.stubResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                            statusCode: statusCode,
                                            httpVersion: nil,
                                            headerFields: nil)
        self.stubError = error
    }
    
    static func clear() {
        stubData = nil
        stubResponse = nil
        stubError = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        if let error = URLProtocolStub.stubError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = URLProtocolStub.stubResponse {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = URLProtocolStub.stubData {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
    }
}

