//
//  File.swift
//  Dessert_Menu
//
//  Created by Ge Ding on 7/3/23.
//

import Foundation

protocol Statusful {
    associatedtype T
    var status: Status<T> { get }
}

enum Status<T> {
    case idle
    case loading
    case loaded(T)
    case error(Error)
}
