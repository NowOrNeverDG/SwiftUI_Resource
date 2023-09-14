//
//  ViewController.swift
//  Weather_APP
//
//  Created by Ge Ding on 6/18/23.
//

import UIKit
import SwiftUI
import Combine
import CoreLocation

class ViewController: UIViewController {
    private var viewModel = WeatherViewModel(client: WeatherAPIClient(), imageLoader: ImageLoader())
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        checkLocationAuthorization()
        
        // Create an instance of LocationView and inject the dependencies
        let locationView = LocationView(viewModel: viewModel)

        // Wrap the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: locationView)

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

extension ViewController: CLLocationManagerDelegate {
    
    func checkLocationAuthorization() {
        let manager = CLLocationManager()
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            // Reverse geocode the user's location to get the city name
                if let location = locationManager.location {
                    let geocoder = CLGeocoder()
                    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                        if let error = error {
                            print("Reverse geocoding error: \(error.localizedDescription)")
                            return
                        }
                        
                        if let placemark = placemarks?.first {
                            if let city = placemark.locality {
                                self.viewModel.fetchWeatherData(from: EndPoint(city: city))
                                return
                            }
                        }
                    }
                }
            break
        case .denied, .restricted:
            do {
                try self.viewModel.loadLastWeatherData(from: EndPoint(city: "Boston"))
            } catch {
                print("loadLastWeatherData Failure: \(error.localizedDescription)")
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        @unknown default:
            break
        }
    }
    
    // CLLocationManagerDelegate method
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}


