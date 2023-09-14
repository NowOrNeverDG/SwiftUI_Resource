//
//  DessertView.swift
//  Dessert_Menu
//
//  Created by Ge Ding on 6/23/23.
//

import SwiftUI
import CachedAsyncImage
struct DessertView: View {
    var meal: Meals
    
    var body: some View { 
        ZStack {
            HStack {
                VStack {
                    Spacer()
                    if let imageURL = URL(string: meal.strMealThumb ?? "") {
                        CachedAsyncImage(url: imageURL, content: { image in
                            image
                                .resizable()
                                .frame(width: 80, height: 80)
                        }, placeholder: {
                            ProgressView()
                                .frame(width: 80, height: 80)
                        })
                    }
                    Spacer()
                }
                VStack {
                    Spacer()
                    // Display the dessert name
                    Text(meal.strMeal ?? "N/A")
                        .padding(.leading,30)
                        .font(.custom("HelveticaNeue-Bold", size: 20))
                    Spacer()
                }
                Spacer()
            }.padding()
        }
    }
}

struct DessertView_Previews: PreviewProvider {
    static var previews: some View {
        DessertView(meal: Meals(strMeal: "", strMealThumb: "", idMeal: ""))
    }
}
