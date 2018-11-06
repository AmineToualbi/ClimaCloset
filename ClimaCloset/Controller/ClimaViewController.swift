//
//  ClimaViewController.swift
//  ClimaCloset
//
//  Created by TOUALBI Amine  on 08/10/2018.
//  Copyright © 2018 ToualbiApps. All rights reserved.
//

import UIKit


class ClimaViewController: UIViewController, UITextFieldDelegate {
  
    let weatherDataModel = WeatherDataModel()
    
    static var pressed : Bool = false
    static var newCity : String = ""
    var cityName : String = ""
    
    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet weak var backgroundClima: UIImageView!
    
    var timeOfDayClima : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cityInput.delegate = self
        updateBackground()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        
        
        if let city = cityInput.text{
            cityName = city
        }
        ClimaViewController.newCity = cityName
        weatherDataModel.city = cityName
        ClimaViewController.pressed = true
        print("CONFIRM CALLED " + String(ClimaViewController.newCity))

        
        
       // let weatherVC = WeatherViewController()
       // let weatherVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherVC") as! WeatherViewController
        
      //  weatherVC.userEnteredNewCityName(city: cityName)
        
        
       // self.dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: - UI Updates
    func updateBackground() {
        
       // print("CLIMA " + String(timeOfDayClima))

//        //Soluce 1
//        timeOfDayClima = WeatherViewController.timeOfDayStatic
//
        if(timeOfDayClima == 0){
            backgroundClima.image = UIImage(named: "Sun BG.png")
            cityInput.keyboardAppearance = .light
        }
        else if(timeOfDayClima == 1){
            backgroundClima.image = UIImage(named: "Moon BG.png")
            cityInput.keyboardAppearance = .dark

        }
        else if(timeOfDayClima == 2){
            backgroundClima.image = UIImage(named: "Blood BG.jpg")
            cityInput.keyboardAppearance = .dark

        }
        
    }
    
    //Dismiss keyboard when user taps outside. 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //Dismiss keyboard when user taps on "Enter" button. 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
}
