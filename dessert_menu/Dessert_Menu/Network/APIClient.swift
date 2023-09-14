//
//  APIClient.swift
//  Dessert_Menu
//
//  Created by Ge Ding on 6/22/23.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class APIClient {
    /// Fetches weather data from the API based on the provided endpoint.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL for the API.
    ///   - endpoint: The endpoint containing additional information for the request.
    /// - Returns: A publisher that emits the fetched weather data or an error.
    func getDessertMenuData<T:Decodable>(baseURL: String,endpoint: EndPoint?) -> AnyPublisher<T, Error> {
        guard let url = createURL(baseURL: baseURL, endpoint) else {
            return Fail<T, Error>(error: APIClientError.invalidURLError).eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw APIClientError.badServerResponseError
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error -> Error in
                return APIClientError.decodingError
            })
            .handleEvents(receiveOutput: {weatherData in
                
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Created the URL for the API request based on the endpoint
    ///
    /// - Parameters:
    ///    - endpoint: The endpoint containing the dessert name
    /// - Returns: The created URL for the API request combine base url and endpoint propely
    private func createURL(baseURL: String,_ endpoint: EndPoint?) -> URL? {
        switch baseURL {
        case BaseURL.dessertBaseURL:
            return URL(string: baseURL)
        case BaseURL.detailBaseURL:
            var components = URLComponents(string: baseURL)
            components?.queryItems = [
                URLQueryItem(name: "i", value: endpoint?.dessert)
            ]
            return components?.url
        default: break
        }
        return nil
    }
}


enum APIClientError:Error {
    case invalidURLError
    case decodingError
    case badServerResponseError
}
