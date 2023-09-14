//
//  EndPoint.swift
//  Dessert_Menu
//
//  Created by Ge Ding on 6/22/23.
//

import Foundation
struct BaseURL {
    static let dessertBaseURL = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    static let detailBaseURL = "https://themealdb.com/api/json/v1/1/lookup.php"
}

struct EndPoint {
    var dessert: String
}
