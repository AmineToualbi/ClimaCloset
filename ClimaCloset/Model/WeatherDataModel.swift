//
//  WeatherDataModel.swift
//  ClimaCloset
//
//  Created by TOUALBI Amine  on 03/11/2018.
//  Copyright © 2018 ToualbiApps. All rights reserved.
//

import Foundation

class WeatherDataModel {
    
    //Model variables retrieved from JSON. 
    static var temperature : Int = 0
     var condition : Int = 0
      var city : String = ""
     var sunset : Int = 0
     var sunrise : Int = 0
    
    func updateConditionLabel(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "Thunderstorm"
            
        case 301...500 :
            return "Drizle"
            
        case 501...600 :
            return "Rainy"
            
        case 601...700 :
            return "Snowy"
            
        case 701...771 :
            return "Foggy"
            
        case 772...799 :
            return "Thunderstorm"
            
        case 800 :
            return "Clear"
            
        case 801...804 :
            return "Cloudy"
            
        case 900...903, 905...1000  :
            return "Thunderstorm"
            
        case 903 :
            return "Snowy"
            
        case 904 :
            return "Clear"
            
        default :
            return ""
        }
        
    }
    
    func updateClosetImage(temperature: Int) -> String {
        
        
        switch (temperature) {
            
        case ..<(-5) :
            return "cold"
            
        case -4...6:
            return "chill"
        
        case 7...16:
            return "average"
            
        case 17...:
            return "warm"
        
        default :
        return ""
        
        }
        
    }
    
    
    
}
