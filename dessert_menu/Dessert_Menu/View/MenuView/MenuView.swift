//
//  MenuView.swift
//  Dessert_Menu
//
//  Created by Ge Ding on 6/23/23.
//

import SwiftUI
import Combine
struct MenuView: View {
    @ObservedObject var menuViewModel: MenuViewModel
    let cancellables = Set<AnyCancellable>()
    
    @State var presentView: Bool = false
    @State var selectedMealPack: mealIDPack?
    var body: some View {
        ScrollView {
            VStack {
                switch menuViewModel.status {
                case .loading:
                    ProgressView()
                        .padding()
                case .loaded(let meals):
                    ForEach(meals, id: \.idMeal) { meal in
                        DessertView(meal: meal)
                            .onTapGesture {
                                if let mealId = meal.idMeal {
                                    presentView.toggle()
                                    selectedMealPack = mealIDPack(mealID: mealId)
                                }
                            }
                    }
                case .idle:
                    EmptyView()
                case .error(_):
                    EmptyView()
                }
            }
            .onAppear{
                menuViewModel.fetchMenuData()
            }
            .sheet(isPresented: $presentView) {
                if let pack = selectedMealPack {
                    DetailView(detailViewModel: DetailViewModel(client: APIClient()), selectedMealPack: $selectedMealPack)
                }
            }

        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(menuViewModel: MenuViewModel(client: APIClient()))
    }
}

struct mealIDPack {
    var mealID : String
}
