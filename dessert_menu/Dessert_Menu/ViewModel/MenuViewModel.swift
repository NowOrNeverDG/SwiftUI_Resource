//
//  ViewModel.swift
//  Dessert_Menu
//
//  Created by Ge Ding on 6/22/23.
//

import Foundation
import Combine
import UIKit

public class MenuViewModel: ObservableObject, Statusful {
    typealias T = [Meals]
    @Published private(set) var status: Status<[Meals]> = .idle
    
    private let client: APIClient
    var cancellables = Set<AnyCancellable>()
    
    init(client: APIClient) {
        self.client = client
    }
    
    /// Fetches menu data to menuView
    ///
    /// - Parameter endpoint: The endpoint to fetch weather data from
    func fetchMenuData() {
        status = .loading
        let dessertPublisher:AnyPublisher<Dessert,Error> = client.getDessertMenuData(baseURL: BaseURL.dessertBaseURL, endpoint: nil)
        dessertPublisher
            .sink { completion in
                if case let .failure(error) = completion {
                    self.status = .error(error)
                }
            } receiveValue: {[weak self] menuData in
                guard let meals = menuData.meals else {
                    self?.status = .error(MenuViewModelError.mealsUnexistedError)
                    return
                }
                DispatchQueue.main.async {
                    self?.status = .loaded(meals)
                }
            }
            .store(in: &cancellables)
    }
}

extension MenuViewModel {
    enum MenuViewModelError: Error {
        case mealsUnexistedError
    }
    
    enum Event {
        case onAppear
        case onSelectMeal(Int)
        case onMealsLoaded([Meals])
        case onFailedToLoadMeals(Error)
    }
}



