//
//  ClimaViewController.swift
//  ClimaCloset
//
//  Created by TOUALBI Amine  on 08/10/2018.
//  Copyright © 2018 ToualbiApps. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredNewCityName(city : String)
}


class ClimaViewController: UIViewController, WeatherDelegate, UITextFieldDelegate {
    func sendTimeInfo(time: Int) {
        
    }
    
    
    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet weak var backgroundClima: UIImageView!
    
    var timeOfDayClima : Int = 0
    
    var delegate : ChangeCityDelegate?
        
    
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
        
        print("CONFIRM CALLED")
        
        let cityName = cityInput.text!
        
        delegate?.userEnteredNewCityName(city: cityName)
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
}
