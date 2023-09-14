//
//  DetailView.swift
//  Dessert_Menu
//
//  Created by Ge Ding on 6/25/23.
//
//
import SwiftUI

struct DetailView: View {
    @ObservedObject var detailViewModel: DetailViewModel
    @Binding var selectedMealPack: mealIDPack?
    
    var body: some View {
        ScrollView {
            VStack {
                switch detailViewModel.status {
                case .loading:
                    ProgressView()
                        .padding()
                case .loaded(let detail):
                    ScrollView {
                        Text("\(detail.strMeal ?? "N/A")")
                            .padding()
                            .bold()
                        VStack {
                            Text("Instruction: \(detail.strInstructions ?? "N/A")")
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom)
                            ForEach(0..<detail.ingredients.count, id: \.self) { index in
                                if let ingredient = detail.ingredients[index], let measure = detail.measures[index] {
                                    Text("\(ingredient):  \(measure)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }.padding()
                    }
                case .idle:
                    ProgressView()
                        .padding()
                case .error(_):
                    EmptyView()
                }
            }.onAppear {
                detailViewModel.fetchDetailsData(endPoint: EndPoint(dessert: selectedMealPack?.mealID ?? ""))
            }
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    @State var mealPack = mealIDPack(mealID: "12345")
//    static var previews: some View {
//        DetailView(detailViewModel: DetailViewModel(client: APIClient()), selectedMealPack: $mealPack)
//    }
//}
