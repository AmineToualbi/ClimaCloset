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
    
    var temperature : Int = 0
    var city : String = ""
    var condition : Int = 0
    
    
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
        //Reports user's movement when location changed by 250 meters.
        locationManager.distanceFilter = 250
        
        
        //NotificationObserver to control when apps comes back from background.
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //Request user authorization to get location when in-use.
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
  
    //MARK - NETWORKING
    
    func getWeatherData(url : String, params : [String : String]){
        
        //Send GET request & expect answer as JSON.
        Alamofire.request(url, method: .get, parameters: params).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("Response received through Alamofire")
                
                //Check if data was received through response. 
                if let json = response.result.value {
                    
                    let dataJSON : JSON = JSON (response.result.value)
                    print(dataJSON)
                    
                    self.updateWeatherData(json : dataJSON)
                    
                }
            }
            
            else {
                print("ERROR \(response.result.error)")
                
                self.cityLabel.text = "Connection Issues"
                
            }
           
        }
        
    }
    
    
    func updateWeatherData(json : JSON){
        
        //We only need to check that one field is filled to ensure the others are.
        if let tempResult = json["main"]["temp"].double {
            
            temperature = Int (tempResult - 273.15)
            city = json["name"].stringValue
            //Use index 0 here bc "weather" contains array & we need to choose index.
            condition = json["weather"][0]["id"].intValue
            
            print("TEMPERATURE " + String(temperature))
            print("CITY " + String(city))
            print("CONDITION " + String(condition))
        }
        
        
    }
    
    
    //MARK - Location
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
            
            //Create Dictionary / Hash Table with parameters that will go into URL of HTTP GET request.
            let params : [String : String] = ["lat" : latitude,
                                                    "lon" : longitude,
                                                    "appid" : APP_ID]
            
            getWeatherData(url : WEATHER_URL, params : params)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailable"
    }
    
    
    //MARK: - Notification Observer Methods
    //Function when app comes back from background.
    @objc func willEnterForeground(){
        print("enters foreground")
        
        //We want to update location when app comes back to foreground.
        locationManager.startUpdatingLocation()
    }


}

