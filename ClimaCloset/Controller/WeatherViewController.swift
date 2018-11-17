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
import LatLongToTimezone




class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    //Instance variable of other classes.
    let weatherDataModel = WeatherDataModel()
    
    var formattingSpaces : String = "   "
    
    static let notificationName = Notification.Name("myNotificationName")
    
    //timeOfDay: 0 = day, 1 = early night, 2 = late night.
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
    
    var long : CLLocationDegrees = 0
    var lat : CLLocationDegrees = 0
    
    static var updateReceived : Bool = false

    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "8300f2d4182612b5d44c3fcb22ca0acc"
    
    let locationManager = CLLocationManager();
    
    
    @IBOutlet weak var tempUnitSegmentControl: UISegmentedControl!
    
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
    
    
    //MARK: - Notification Observer Methods
    //Function when app comes back from background.
    @objc func willEnterForeground(){
        print("enters foreground")
        
        //We want to update location and check time when app comes back to foreground.
        locationManager.startUpdatingLocation()
        
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
            lat = location.coordinate.latitude
            long = location.coordinate.longitude
            print("Lat : " + latitude + " Longit : " + longitude)
            
            //Create Dictionary / Hash Table with parameters that will go into URL of HTTP GET request.
            let params : [String : String] = ["lat" : latitude,
                                              "lon" : longitude,
                                              "appid" : APP_ID]
            
            getWeatherData(url : WEATHER_URL, params : params)
            
        }
    }
    
    //Fail of locationManager.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = formattingSpaces + "Location Unavailable"
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
            
                self.cityLabel.text = self.formattingSpaces + "Connection Issues"
                
            }
        }
    }
    
    
    func updateWeatherData(json : JSON){
        
        //We only need to check that one field is filled to ensure the others are.
        if let tempResult = json["main"]["temp"].double {
            
//            weatherDataModel.temperature = Int (tempResult - 273.15)
            WeatherDataModel.temperature = Int (tempResult)
            weatherDataModel.city = json["name"].stringValue
            //Use index 0 here bc "weather" contains array & we need to choose index.
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.sunrise = json["sys"]["sunrise"].intValue
            weatherDataModel.sunset = json["sys"]["sunset"].intValue
            
            //Set lat & long to JSON values bc we don't already have it if user inputs city name.
            lat = json["coord"]["lat"].doubleValue
            long = json["coord"]["lon"].doubleValue
            
            print("TEMPERATURE " + String(WeatherDataModel.temperature))
            print("CITY " + String(weatherDataModel.city))
            print("CONDITION " + String(weatherDataModel.condition))
            print("SUNRISE " + String(weatherDataModel.sunrise))
            print("SUNSET " + String(weatherDataModel.sunset))
            print("LAT " + String(lat))
            print("LONG " + String(long))
            
            WeatherViewController.updateReceived = true
            updateUI()
            
        }
        else {
            print("CITYNOTFOUNDE")
            cityLabel.text = formattingSpaces + "City Not Found"
            temperatureLabel.text = ""
            conditionLabel.text = "Insert a new city"
        }
    }
    
    
    //MARK: - UI Updates
    func updateUI() {
        
        var temp: Double = 0
        if(tempUnitSegmentControl.selectedSegmentIndex == 0){
            temp = Double(WeatherDataModel.temperature) - 273.15
        }
        else if (tempUnitSegmentControl.selectedSegmentIndex == 1) {
            temp = 9/5 * (Double(WeatherDataModel.temperature) - 273.15) + 32
        }
        
        if(temp > -1 && temp < 1) {
            temperatureLabel.text = "0°"    //To fix bug showing - 0.
        }
        else {
            //Format temp to 0 decimal places.
            temperatureLabel.text = String(format: "%.0f", temp) + "°"
        }
        cityLabel.text = formattingSpaces + weatherDataModel.city
        conditionLabel.text = weatherDataModel.updateConditionLabel(condition: weatherDataModel.condition)
        
        timeOfDay = checkTime()
        
        if(timeOfDay == 0){
            backgroundImage.image = UIImage(named: "Sun.png")
        }
        else if(timeOfDay == 1){
            backgroundImage?.image = UIImage(named: "Moon.png")
        }
        else if(timeOfDay == 2){
            backgroundImage.image = UIImage(named: "Blood.jpg")
        }
        
        //Initialize the 2 other Views after updating to ensure that data gets passed along to "not nil" views.
        let climaVC = ClimaViewController()
        let closetVC = ClosetViewController()
        
        if closetVC.viewAlreadyInitialized {
            closetVC.updateBackground()
        }
        
    }
    
    
    //MARK: - Check Time
    func checkTime() -> Int {
        
        //Retrieve time zone.
        let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let timeZone = TimezoneMapper.latLngToTimezone(location)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd hh:mm:ss"
        dateFormatter.timeZone = timeZone
        
        print("TIME IN " + cityLabel.text! + " IS " + dateFormatter.string(from: Date()))
        
        currentTime = dateFormatter.string(from: Date())
        print(currentTime)

      //  This part gets when the sun rises.
        let sunriseUTC = NSDate(timeIntervalSince1970: TimeInterval(weatherDataModel.sunrise))
        //sunriseTime = DateFormatter.localizedString(from: sunriseUTC as Date, dateStyle: .short, timeStyle: .short)
        sunriseTime = dateFormatter.string(from: sunriseUTC as Date)
        print(sunriseTime)
        
        //This part gets when sun sets.
        let sunsetUTC = NSDate(timeIntervalSince1970: TimeInterval(weatherDataModel.sunset))
        let sunsetTime = dateFormatter.string(from: sunsetUTC as Date)
        
        //We need the time as integer to compare it.
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
        else if(currentTimeHour >= nightSeparationHour){
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
    
    //If timeType = 0, we are calculating current time. If timeType = 1 => sunrise. If timeType = 2 => sunset.
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
    
    @IBAction func temperatureUnitChanged(_ sender: Any) {
        
        updateUI()
//        switch tempUnitSegmentControl.selectedSegmentIndex {
//        case 0:
//            weatherDataModel.temperature = weatherDataModel.temperature - 273
//            temperatureLabel.text = String (weatherDataModel.temperature)
//            break
//        case 2:
//            weatherDataModel.temperature = Int (9/5 * (weatherDataModel.temperature - 273) + 32)
//            temperatureLabel.text = String (weatherDataModel.temperature)
//            break
//        default:
//            break
//        }
    }
    
    func userEnteredNewCityName(city: String) {
        
        ClimaViewController.pressed = false
        print("DATA RECEIVED")

        let params : [String: String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, params: params)

    }
    
    
  
}


