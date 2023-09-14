//
//  DetailViewModel.swift
//  Dessert_Menu
//
//  Created by Ge Ding on 6/25/23.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject, Statusful {
    typealias T = Detail
    @Published private(set) var status: Status<Detail> = .idle

    private let client: APIClient
    private var cancellables = Set<AnyCancellable>()
    init(client: APIClient) {
        self.client = client
    }
    
    /// Fetches detail data from the specified endpoint to DetailView.
    ///
    /// - Parameter endpoint: The endpoint to fetch weather data from
    func fetchDetailsData(endPoint: EndPoint) {
        status = .loading
        let dessertPublisher:AnyPublisher<Details, Error> = client.getDessertMenuData(baseURL: BaseURL.detailBaseURL, endpoint: endPoint)
        dessertPublisher
            .sink { completion in
                if case let .failure(error) = completion {
                    self.status = .error(error)
                }
            } receiveValue: { [weak self] detailsData in
                guard let detail = detailsData.meals?[0] else {
                    self?.status = .error(DetailViewModelError.detailUnxistedError)
                    return
                }
                DispatchQueue.main.async {
                    self?.status = .loaded(detail)
                }
            }
            .store(in: &cancellables)
    }
}

extension DetailViewModel {
    enum DetailViewModelError: Error {
        case detailUnxistedError
    }
}
