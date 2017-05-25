//
//  Buisness.swift
//  YelpQuiz
//
//  Created by Георгий Иванов on 25.05.17.
//  Copyright © 2017 George Ivanov. All rights reserved.
//

import UIKit
import CoreLocation

class Business: NSObject {
    let fullDict: Any?
    let coordinates: CLLocationCoordinate2D?
    let url: URL?
    let rating: Int?
    let name: String?
    let address: String?
    let imageURL: URL?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        let location = dictionary["location"] as? NSDictionary
        var address = ""
        var coordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        if location != nil {
            let coordinateArray = location!["coordinate"] as? NSDictionary
            let latitude = coordinateArray!["latitude"] as! Double
            let longitude = coordinateArray!["longitude"] as! Double
            coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let addressArray = location!["address"] as? NSArray
            if addressArray != nil && addressArray!.count > 0 {
                address = addressArray![0] as! String
            }
            
            let neighborhoods = location!["neighborhoods"] as? NSArray
            if neighborhoods != nil && neighborhoods!.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoods![0] as! String
            }
        }
        self.coordinates = coordinates
        self.address = address
        
        rating = dictionary["rating"] as? Int
        
        fullDict = dictionary 
        
        let urlString = dictionary["url"] as! String
        if urlString != nil {
            url = URL(string: urlString)
        } else {
            url = nil
        }

    }
    
    
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    
    class func searchWithLocation(latitude: Double, longitude: Double, completion: @escaping ([Business]?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithLocation(latitude: latitude, longitude: longitude, completion: completion)
    }

    
    
}
