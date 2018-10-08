//
//  Round Button.swift
//  ClimaCloset
//
//  Created by TOUALBI Amine  on 07/10/2018.
//  Copyright © 2018 ToualbiApps. All rights reserved.
//

import UIKit

@IBDesignable       //IBDesignable makes it usable through the Interface Builder.
class RoundButton: UIButton {
    
    //IBInspectable allows this value to show up in AttributeInspector.
    //didSet allows cornerRadius to change when it's changed on the Storyboard.
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor    //.cgColor forces borderColor type.
        }
    }
    
    
    
    
    
    
    
}
