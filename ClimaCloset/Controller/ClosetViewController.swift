//
//  ClosetViewController.swift
//  ClimaCloset
//
//  Created by TOUALBI Amine  on 08/10/2018.
//  Copyright © 2018 ToualbiApps. All rights reserved.
//

import UIKit

class ClosetViewController: UIViewController {
    
    
    @IBOutlet weak var backgroundCloset: UIImageView!
    
    @IBOutlet weak var outfitImage: UIImageView!
    var timeOfDayCloset : Int = 0
    var viewAlreadyInitialized : Bool = false
    
    let weatherDataModel = WeatherDataModel()
    
    let averageOutfits = ["Average 1", "Average2", "Average 3", "Average 4"]
    let chillOutfits = ["Chill 1", "Chill 2", "Chill 3", "Chill 4", "Chill 5"]
    let coldOutfits = ["Cold 1", "Cold 2", "Cold 3"]
    let warmOutfits = ["Warm 1", "Warm 2", "Warm 3", "Warm 4"]
    
    var previousCityInputted: String = ""
    static var updateOutfitControl: Int = 0
    var updateOutfitControlComparator: Int = (-1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        updateBackground()
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - UI Updates
    func updateBackground() {
        
//        //Soluce 1
//        timeOfDayCloset = WeatherViewController.timeOfDayStatic
        
        if(timeOfDayCloset == 0){
            backgroundCloset.image = UIImage(named: "Sun BG.png")
        }
        else if(timeOfDayCloset == 1){
            backgroundCloset.image = UIImage(named: "Moon BG.png")
        }
        else if(timeOfDayCloset == 2){
            backgroundCloset.image = UIImage(named: "Blood BG.jpg")
        }
        
        viewAlreadyInitialized = true
        
        print ("UPDATE RESEIVED = " + String(WeatherViewController.updateReceived))
        
        if(updateOutfitControlComparator + 1 == ClosetViewController.updateOutfitControl && WeatherViewController.updateReceived == true) {
            updateOutfitControlComparator += 1
            updateOutfit()
            WeatherViewController.updateReceived = false
        }
        
    }
    
    func updateOutfit() {
        
        
        let temp = Double(WeatherDataModel.temperature) - 273.15
        
        let outfit: String = weatherDataModel.updateClosetImage(temperature: Int(temp))
        
        print("Temperature is " + String(temp))
        
        
        if (outfit == "chill") {
            print("CHILL SELECTED")
            let random: Int = Int(arc4random_uniform(5))
            print ("RANDOM = " + String(random))

            outfitImage.image = UIImage(named: chillOutfits[random])
        }
        
        else if (outfit == "average") {
            print ("AVERAGE SELECTED")
            let random: Int = Int(arc4random_uniform(4))
            print ("RANDOM = " + String(random))
            outfitImage.image = UIImage(named: averageOutfits[random])
        }
            
        else if (outfit == "cold") {
            print ("COLD SELECTED")
            let random: Int = Int(arc4random_uniform(3))
            print ("RANDOM = " + String(random))

            outfitImage.image = UIImage(named: coldOutfits[random])
        }
        
        else if (outfit == "warm") {
            print ("WARM SELECTED")
            let random: Int = Int(arc4random_uniform(4))
            print ("RANDOM = " + String(random))

            outfitImage.image = UIImage(named: warmOutfits[random])
        }
        
    }
    
}
