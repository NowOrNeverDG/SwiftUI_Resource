//
//  ViewModel.swift
//  Weather_APP
//
//  Created by Ge Ding on 6/18/23.
//

import Foundation
import Combine
import UIKit

class WeatherViewModel: ObservableObject {
    @Published var weatherData: CityWeather?
    @Published var weatherImage: UIImage?

    private let client: WeatherAPIClient
    private let imageLoader: ImageLoader
    private var cancellables = Set<AnyCancellable>()

    init(client: WeatherAPIClient, imageLoader: ImageLoader) {
        self.client = client
        self.imageLoader = imageLoader
    }
    
    /// Fetches weather data from the specified endpoint.
    ///
    /// - Parameter endpoint: The endpoint to fetch weather data from
    func fetchWeatherData(from endpoint:EndPoint) {
        client.getWeatherData(from: endpoint)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("fetchWeatherData Failure:\(error.localizedDescription)")
                }
            } receiveValue: { [weak self] weatherData in
                DispatchQueue.main.async {
                    self?.weatherData = weatherData
                    do {
                        try self?.loadImage(iconURL: weatherData.weather?[0].icon)
                    } catch {
                        print("loadImageError:\(error.localizedDescription)")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    /// Loads the last saved weather data or fetches new data from the specified endpoint.
    ///
    /// - Parameter endpoint: The endpoint to fetch weather data from if last data is not available.
    func loadLastWeatherData(from endpoint:EndPoint) throws {
        if let lastWeatherData = try WeatherAPIClient.getLastWeatherData() {
            weatherData = lastWeatherData
            let iconURL = lastWeatherData.weather?[0].icon
            
            do {
                try loadImage(iconURL: iconURL)
            } catch {
                print("loadLastWeatherDataError:\(error.localizedDescription)")
            }
        } else {
            fetchWeatherData(from: endpoint)
        }
    }
    
    /// Loads the weather image from the specified URL.
    ///
    /// - Parameter iconURL: The URL of the weather image.
    private func loadImage(iconURL: String?) throws {
        guard let url = iconURL else { return }
        
        imageLoader.loadImage(from: url)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("loadImage Failure: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] image in
                self?.weatherImage = image
            }
            .store(in: &cancellables)
    }
}

enum WeatherLoadError: Error {
    case dataLoadError
    case imageLoadError
}
