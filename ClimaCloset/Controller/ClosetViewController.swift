//
//  ClosetViewController.swift
//  ClimaCloset
//
//  Created by TOUALBI Amine  on 08/10/2018.
//  Copyright © 2018 ToualbiApps. All rights reserved.
//

import UIKit

class ClosetViewController: UIViewController {
    
    @IBOutlet weak var topItem: UIImageView!
    @IBOutlet weak var pantsItem: UIImageView!
    @IBOutlet weak var shoesItem: UIImageView!
    @IBOutlet weak var backgroundCloset: UIImageView!
    
    var timeOfDayCloset : Int = 0
    
    
    
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
        
        
        timeOfDayCloset = WeatherViewController.timeOfDayStatic
        
        if(timeOfDayCloset == 0){
            backgroundCloset.image = UIImage(named: "Sun BG.png")
        }
        else if(timeOfDayCloset == 1){
            backgroundCloset.image = UIImage(named: "Moon BG.png")
        }
        else if(timeOfDayCloset == 2){
            backgroundCloset.image = UIImage(named: "Blood BG.jpg")
        }
        
    }
    
}
