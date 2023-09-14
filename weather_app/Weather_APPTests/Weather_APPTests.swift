//
//  Weather_APPTests.swift
//  Weather_APPTests
//
//  Created by Ge Ding on 6/18/23.
//

import XCTest
import Combine

@testable import Weather_APP

final class Weather_APPTests: XCTestCase {
    var cancellables: Set<AnyCancellable>?
    var viewModel: WeatherViewModel?
    
    override func setUpWithError() throws {
        cancellables = Set<AnyCancellable>()
        viewModel = WeatherViewModel(client: WeatherAPIClient(), imageLoader: ImageLoader())
    }

    override func tearDownWithError() throws {
        cancellables = nil
        viewModel = nil
    }
    
    func testFetchWeatherData() {
        let expectation = XCTestExpectation(description: "Fetch weather data")
        let mockEndpoint = EndPoint(city: "Miami")
        viewModel?.fetchWeatherData(from: mockEndpoint)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            XCTAssertNotNil(self.viewModel?.weatherData)
            XCTAssertNotNil(self.viewModel?.weatherImage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testLoadLastWeatherData() {
        let expectation = XCTestExpectation(description: "Load last weather data")
        let mockEndpoint = EndPoint(city: "Boston")
        do {
            try viewModel?.loadLastWeatherData(from: mockEndpoint)
        } catch {
            print("testLoadLastWeatherData failure: \(error)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            XCTAssertNotNil(self.viewModel?.weatherData)
            XCTAssertNotNil(self.viewModel?.weatherImage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
