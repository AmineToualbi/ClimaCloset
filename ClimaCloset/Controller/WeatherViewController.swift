//
//  ViewController.swift
//  ClimaCloset
//
//  Created by TOUALBI Amine  on 06/10/2018.
//  Copyright © 2018 ToualbiApps. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "8300f2d4182612b5d44c3fcb22ca0acc"
    
    let locationManager = CLLocationManager();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TODO: Set up location manager here
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        //Request user authorization to get location when in-use.
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation();
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Receive Location Information from Delegate.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Array locations[] stores location.
        //locations[1] is rough estimation & last one is most precise.
        let location = locations[locations.count - 1];
    
        
        //If location is valid: (horizontalAccuracy < 0 = invalid)
        if(location.horizontalAccuracy > 0){
            
            locationManager.stopUpdatingLocation()  //Stop updating bc process is battery intensive.
            let latitude = String (location.coordinate.latitude)
            let longitude = String (location.coordinate.longitude)
            
            print("Lat : " + latitude + " Longit : " + longitude)
            cityLabel.text = "Lat : " + latitude + " Longit : " + longitude
            
        }
        
    }


}

