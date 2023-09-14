//
//  Dessert_MenuTests.swift
//  Dessert_MenuTests
//
//  Created by Ge Ding on 6/22/23.
//

import XCTest
import Combine
@testable import Dessert_Menu

final class Dessert_MenuTests: XCTestCase {
    var cancellables: Set<AnyCancellable>?
    var menuViewModel: MenuViewModel?
    var detailViewModel: DetailViewModel?

    override func setUpWithError() throws {
        cancellables = Set<AnyCancellable>()
        menuViewModel = MenuViewModel(client: APIClient())
        detailViewModel = DetailViewModel(client: APIClient())
    }

    override func tearDownWithError() throws {
        cancellables = nil
        menuViewModel = nil
        detailViewModel = nil
    }
    
    func testFetchMenuData() {
        let expectation = XCTestExpectation(description: "Fetch Menu data")
        menuViewModel?.fetchMenuData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertNotNil(self.menuViewModel?.menuData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchDetailData() {
        let expectation = XCTestExpectation(description: "Fetch Detail data")
        detailViewModel?.fetchDetailsData(endPoint: EndPoint(dessert: "53049"))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertNotNil(self.detailViewModel?.dessertDetail)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }


}
