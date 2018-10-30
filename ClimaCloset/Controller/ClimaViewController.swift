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


class ClimaViewController: UIViewController, WeatherDelegate {
    func sendTimeInfo(time: Int) {
        
    }
    
    
    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet weak var backgroundClima: UIImageView!
    
    var timeOfDayClima : Int = 0
    
    var delegate : ChangeCityDelegate?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        print("CLIMA " + String(timeOfDayClima))

        //timeOfDayClima = WeatherViewController.timeOfDayStatic
        
        if(timeOfDayClima == 0){
            backgroundClima.image = UIImage(named: "Sun BG.png")
        }
        else if(timeOfDayClima == 1){
            backgroundClima.image = UIImage(named: "Moon BG.png")
        }
        else if(timeOfDayClima == 2){
            backgroundClima.image = UIImage(named: "Blood BG.jpg")
        }
        
    }
    
//    func sendTimeInfo(time: Int) {
//
//       timeOfDayClima = time
//        print("TIME CLIMA IS " + String(timeOfDayClima))
//
//    }
    
}
