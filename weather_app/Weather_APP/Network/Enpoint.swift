//
//  Enpoint.swift
//  Weather_APP
//
//  Created by Ge Ding on 6/18/23.
//

import Foundation

struct EndPoint {
    var apiKey = "4dcb06048d8edcea56b234c02a46c338"
    var city: String
}

struct BaseURL {
    static let dataBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    static let imageBaseURL = "https://openweathermap.org/img/wn/"
}
