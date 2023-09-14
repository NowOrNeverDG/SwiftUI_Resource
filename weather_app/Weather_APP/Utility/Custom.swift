//
//  Custom.swift
//  Weather_APP
//
//  Created by Ge Ding on 6/18/23.
//

import Foundation
import SwiftUI

/// MARK - A modifier to use in "weather information" and "wind information" on main screen as decoration
struct StardardFont: ViewModifier {
    // Applies the specified font, color, padding, background, corner radius, and shadow to the content
    func body(content: Content) -> some View {
        content
            .font(.custom("HelveticaNeue-Bold", size: 12))
            .foregroundColor(.black)
            .padding()
            .background(Color(red: Double(255)/255.0, green: Double(250)/255.0, blue: Double(205)/255.0))
            .cornerRadius(10)
            .shadow(color: .black, radius: 4, x: 0, y: 2)
            .frame(alignment: .top)
    }
}
extension View {
    // Adds the StardardFont modifier to the view
    func stardardFont() -> some View {
        modifier(StardardFont())
    }
}
