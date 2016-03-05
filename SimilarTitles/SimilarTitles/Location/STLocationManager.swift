//
//  STLocationManager.swift
//  SimilarTitles
//
//  Created by Armen Abrahamyan on 1/29/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import Foundation
import CoreLocation

/**
* Provides methods to get user's current location over 'STLocationManager' wrapper
*/
protocol STLocationManagerDelegate {
    func succeedUserLocation(location: CLLocationCoordinate2D?)
    func failedUserLocation(error: NSError?)
}

/**
* Wrapper over CLLocationManager, handles basic location requests and handling of delegates
*/
class STLocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: Members and lazy member
    lazy var locationManager = CLLocationManager()
    var currentUserLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    // Delegate one
    var delegate: STLocationManagerDelegate?
    
    //MARK: Constructor
    init(accuracy: CLLocationAccuracy) {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = accuracy
        // Request location
        requestStLocation()
    }
    
    //MARK: Hit first time location
    private func requestStLocation() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            locationManager.requestLocation();
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: CLLocationManagerDelegate part
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
        
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if currentUserLocation.latitude == 0 && currentUserLocation.longitude == 0 {
            currentUserLocation = (locations.last?.coordinate)!
            delegate?.succeedUserLocation(currentUserLocation)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error getting location: \(error.localizedDescription)")
        delegate?.failedUserLocation(error)
    }
}




