//
//  Login Gradient.swift
//  Jot
//
//  Created by Mathew Scullin on 1/26/19.
//  Copyright © 2019 Mathew Scullin. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

func setGradient(colorOne: UIColor, colorTwo: UIColor) {
    
    let gradient = CAGradientLayer()
    gradient.frame = UIScreen.main.bounds
    gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
    gradient.locations = [0.0, 1.0]
    gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
    gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
    
    layer.insertSublayer(gradient, at: 0)
    }
    
func setGradientSmall(colorOne: UIColor, colorTwo: UIColor) {
    
    let gradient = CAGradientLayer()
    gradient.frame = UIScreen.main.bounds
    gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
    gradient.locations = [0.3, 1.0]
    gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
    gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
    
    layer.insertSublayer(gradient, at: 0)
}

    
}
