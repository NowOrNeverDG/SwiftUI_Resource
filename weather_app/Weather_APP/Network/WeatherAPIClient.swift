//
//  APIHandler.swift
//  Weather_APP
//
//  Created by Ge Ding on 6/18/23.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class WeatherAPIClient {
    /// Fetched weather data from the API based on the provided endpoint
    ///
    /// - Parameter endpoint: The endpoint containing the city and API key. (API is default so that it don't need to set normally)
    /// - Returns: A publisher that emits the fetched `CityWeather` data or an error.
    func getWeatherData(from endpoint: EndPoint) -> AnyPublisher<CityWeather, Error> {
        let url = createURL(endpoint)
        let request = URLRequest(url: url)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                // Ensure a successful response from the server
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw WeatherAPIError.badServerResponseError
                }
                return data
            }
            .decode(type: CityWeather.self, decoder: JSONDecoder())
            .tryCatch { error -> AnyPublisher<CityWeather, Error> in
                // Handle decoding errors and provide a fallback value or perform additional error handling
                throw WeatherAPIError.decodingError
            }
            .handleEvents(receiveOutput: { [weak self] weatherData in
                // Save the weather data to UserDefaults
                do {
                    try self?.saveWeatherData(weatherData)
                } catch {
                    print("Saved Failure: \(error)")
                }
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Created the URL for the API request based on the endpoint
    ///
    /// - Parameter endpoint: The endpoint containing the city and API key.
    /// - Returns: The created URL for the API request combine base url and endpoint propely
    private func createURL(_ endpoint: EndPoint) -> URL {
        var components = URLComponents(string: BaseURL.dataBaseURL)!
        components.queryItems = [
           URLQueryItem(name: "q", value: "\(endpoint.city)"),
           URLQueryItem(name: "appid", value: endpoint.apiKey)
        ]
        return components.url!
    }
    
    /// Saved the weather data to UserDefaults
    ///
    /// - Parameter weatherData: The weather data to be saved.
    private func saveWeatherData(_ weatherData: CityWeather) throws {
        do {
            let encodedData = try JSONEncoder().encode(weatherData)
            UserDefaults.standard.set(encodedData, forKey: "lastWeatherData")
        } catch {
            throw WeatherAPIError.savingError
        }
    }
    
    /// Retrieved the last saved weather data from UserDefaults
    ///
    /// - Returns: The last saved `CityWeather` data, or `nil` if not found or decoding fails.
    static func getLastWeatherData() throws -> CityWeather? {
        guard let encodedData = UserDefaults.standard.data(forKey: "lastWeatherData") else {
            return nil
        }
        do {
            let decodedData = try JSONDecoder().decode(CityWeather.self, from: encodedData)
            return decodedData
        } catch {
            throw WeatherAPIError.retrievalError
        }
    }
}

enum WeatherAPIError:Error {
    case decodingError
    case badServerResponseError
    case savingError
    case retrievalError
}
