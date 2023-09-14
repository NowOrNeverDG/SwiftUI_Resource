//
//  details.swift
//  Dessert_Menu
//
//  Created by Ge Ding on 6/25/23.
//

import Foundation

struct Details : Codable {
    let meals : [Detail]?

    enum CodingKeys: String, CodingKey {
        case meals = "meals"
    }
}
