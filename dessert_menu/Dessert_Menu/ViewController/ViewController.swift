//
//  ViewController.swift
//  Dessert_Menu
//
//  Created by Ge Ding on 6/22/23.
//

import UIKit
import SwiftUI
import Combine

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create an instance of LocationView and inject the dependencies
        let menuView = MenuView(menuViewModel: MenuViewModel(client: APIClient()))
        // Wrap the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: menuView)
       // Add the hosting controller as a child view controller
       addChild(hostingController)
       view.addSubview(hostingController.view)
        // Configure the hosting controller's view constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }


}

