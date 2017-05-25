//
//  ViewController.swift
//  YelpQuiz
//
//  Created by Георгий Иванов on 25.05.17.
//  Copyright © 2017 George Ivanov. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class ViewController: UIViewController, GMSMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var businesses: [Business]!
    let iconImage = UIImage(named: "logo")
    
    override func loadView() {
        
        // Setting up GMS
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 17)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        //setting zoom range
        mapView.setMinZoom(17, maxZoom: 30)
        
        view = mapView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getting user location and setting it on map
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        //checking if location if avilable and moving camera to current location
        if locationManager.location != nil {
            let mapView = view as! GMSMapView
            let target = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
            mapView.camera = GMSCameraPosition(target: target, zoom: 15, bearing: 0, viewingAngle: 0)
        }
    }
    
    
    //func that adds new POI based on coordinates
    func updatePointOfInterest(latitude: Double,longitude:Double) {
        //latitude: 40.718247, longitude: -73.906581
        Business.searchWithLocation(latitude: latitude, longitude: longitude) { (businesses: [Business]?, error: Error?) -> Void in
            let mapView = self.view as! GMSMapView
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    print("\(business.name!) added on map!")
                    let info = "\(business.address!)\nRaing: \(business.rating!)/5\nTap to open more.."
                    self.placeMarker(tittle: business.name!, snippet: info, URL: business.url!, position: business.coordinates!)
                }
            }
        }
    }
    
    
    //func that place a marker on a map
    func placeMarker(tittle: String, snippet: String, URL: URL, position: CLLocationCoordinate2D) {
        let marker = GMSYelpMarker()
        marker.position = position
        marker.title = tittle
        marker.snippet = snippet
        marker.yelpUrl = URL
        marker.icon = iconImage
        marker.map = view as? GMSMapView
    }
    
    
    //called after camera finished moving or scrolling
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        //reloading markers on map
        updatePointOfInterest(latitude: position.target.latitude, longitude: position.target.longitude)
    }
    
    
    //called after mapView item been tapped to open webwindow with more
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        //this func works only with original class GMSMarker, so we downcast it to GMSYelpMarker here
        if let yelpMarker = marker as? GMSYelpMarker {
            if yelpMarker.yelpUrl != nil {
                UIApplication.shared.open(yelpMarker.yelpUrl!, options: [:], completionHandler: nil)
            }
        }
    }
    
    
}

