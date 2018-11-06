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
    
    //Instance variable of other classes.
    let weatherDataModel = WeatherDataModel()

    
    //Data retrieved from JSON.
   // var temperature : Int = 0
//    var city : String = ""
//    var condition : Int = 0
   // var sunrise : Int = 0
   // var sunset : Int = 0
    
    var formattingSpaces : String = "   "
    
    static let notificationName = Notification.Name("myNotificationName")

    
    //timeOfDay will represent time of the day. 0 = day, 1 = early night, 2 = late night.
    var timeOfDay : Int = 0
    static var timeOfDayStatic : Int = 0

    
    var currentTime : String = ""
    var sunriseTime : String = ""
    var sunsetTime : String = ""
    var currentTimeHour : Int = 0
    var currentTimeMin : Int = 0
    var sunsetHour : Int = 0
    var sunsetMin : Int = 0
    var sunriseHour : Int = 0
    var sunriseMin : Int = 0

    
    
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
            
            weatherDataModel.temperature = Int (tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            //Use index 0 here bc "weather" contains array & we need to choose index.
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.sunrise = json["sys"]["sunrise"].intValue
            weatherDataModel.sunset = json["sys"]["sunset"].intValue
            
            print("TEMPERATURE " + String(weatherDataModel.temperature))
            print("CITY " + String(weatherDataModel.city))
            print("CONDITION " + String(weatherDataModel.condition))
            print("SUNRISE " + String(weatherDataModel.sunrise))
            print("SUNSET " + String(weatherDataModel.sunset))
            
            updateUI()
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
        
        //We want to update location and check time when app comes back to foreground.
        locationManager.startUpdatingLocation()
        
    }
    
    
    //MARK: - Check Time
    func checkTime() -> Int {
        
        let calendar = Calendar.current
        //now is in the format 2018-10-25 06:21:42
        let now = Date()
        //localizedString gets time of current time zone.
        currentTime = DateFormatter.localizedString(from: now, dateStyle: .short, timeStyle: .short)
        print(currentTime)

        //This part gets when the sun rises.
        let sunriseUTC = NSDate(timeIntervalSince1970: TimeInterval(weatherDataModel.sunrise))
        sunriseTime = DateFormatter.localizedString(from: sunriseUTC as Date, dateStyle: .short, timeStyle: .short)
        print(sunriseTime)
        
        //This part gets when sun sets.
        let sunsetUTC = NSDate(timeIntervalSince1970: TimeInterval(weatherDataModel.sunset))
        let sunsetTime = DateFormatter.localizedString(from: sunsetUTC as Date, dateStyle: .short, timeStyle: .short)
        print(sunsetTime)
        
        
        convertTimeToInt(timeString: currentTime, timeType: 0)
        convertTimeToInt(timeString: sunriseTime, timeType: 1)
        convertTimeToInt(timeString: sunsetTime, timeType: 2)
        
        let nightSeparationHour = 23
        
        //Compare current time to sunset & sunrise time to set background of UI.
        //Case 1 = EARLY NIGHT
        if (currentTimeHour >= sunsetHour && currentTimeHour < nightSeparationHour){
            if(currentTimeHour == sunsetHour && currentTimeMin >= sunsetMin){
                timeOfDay = 1
                WeatherViewController.timeOfDayStatic = timeOfDay
                return 1
            }
            else if(currentTimeHour > sunsetHour){
                timeOfDay = 1
                WeatherViewController.timeOfDayStatic = timeOfDay
                return 1
            }
        }

        //Case 2 = LATE NIGHT
        else if(currentTimeHour > nightSeparationHour){
            timeOfDay = 2
            WeatherViewController.timeOfDayStatic = timeOfDay
            return 2
        }
        else if(currentTimeHour <= sunriseHour){
            if(currentTimeHour == sunriseHour && currentTimeMin <= sunriseMin) {
                timeOfDay = 2
                WeatherViewController.timeOfDayStatic = timeOfDay
                return 2
            }
            if(currentTimeHour < sunriseHour) {
                timeOfDay = 2
                WeatherViewController.timeOfDayStatic = timeOfDay
                return 2
            }
        }

        timeOfDay = 0
        WeatherViewController.timeOfDayStatic = timeOfDay
        return 0
        
    }
    
    //If timeType = 0, we are calculating current tine. If timeType = 1 => sunrise. If timeType = 2 => sunset.
    func convertTimeToInt(timeString : String, timeType : Int){
        
        let startIndexHour = timeString.index(timeString.startIndex, offsetBy: 11)
        let endIndexHour = timeString.index(timeString.startIndex, offsetBy: 12)
        
        //Get hour of sunrise
        //Ensure sunriseHour is not nil to avoid crash.
        if let checkNil = (Int) (String(timeString[startIndexHour...endIndexHour])){
            
            if(timeType == 0){
                currentTimeHour = checkNil
                print(currentTimeHour)
            }
                
            else if(timeType == 1){
                sunriseHour = checkNil
                print(sunriseHour)
            }
                
            else if(timeType == 2){
                sunsetHour = checkNil
                print("Sunset hour \(sunsetHour)")
            }
            
        }
        
        let startIndexMin = timeString.index(timeString.startIndex, offsetBy: 14)
        let endIndexMin = timeString.index(timeString.startIndex, offsetBy: 15)
        
        //Get minute of sunrise.
        //Ensure sunriseMin is not nil to avoid crash.
        if let checkNil = (Int) (String(timeString[startIndexMin...endIndexMin])){
            if(timeType == 0){
                currentTimeMin = checkNil
                print(currentTimeMin)
            }
            else if(timeType == 1){
                sunriseMin = checkNil
                print(sunriseMin)
            }
            else if(timeType == 2){
                sunsetMin = checkNil
                print("Sunset min \(sunsetMin)")
            }

            
        }
        
    }
    
    
    
    //MARK: - UI Updates
    func updateUI() {
        
        temperatureLabel.text = String (weatherDataModel.temperature) + "°"
        cityLabel.text = formattingSpaces + weatherDataModel.city
        conditionLabel.text = weatherDataModel.updateConditionLabel(condition: weatherDataModel.condition)
        
        if(checkTime() == 0){
            backgroundImage.image = UIImage(named: "Sun.png")
        }
        else if(checkTime() == 1){
            backgroundImage?.image = UIImage(named: "Moon.png")
        }
        else if(checkTime() == 2){
            backgroundImage.image = UIImage(named: "Blood.jpg")
        }
        
    }

    
    
    func userEnteredNewCityName(city: String) {
        
        print("DATA RECEIVED")

        let params : [String: String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, params: params)

    }
    
    
  
}


