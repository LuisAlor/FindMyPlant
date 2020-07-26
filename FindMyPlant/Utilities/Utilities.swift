//
//  Utilities.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 23.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

class Utilities {
    
    //Creates the TextField's style
    static func styleFormTextField(_ textfield:UITextField, placeholder: String) {
        // Create the bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        // Remove border on text field
        textfield.borderStyle = .none
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textfield.textColor = UIColor.darkGray
        textfield.clearButtonMode = .whileEditing

    }

    //Fills round corner style to button
    static func styleFilledButton(_ button:UIButton) {
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }
    
    //Verifies password that matches the pattern.
    static func isPasswordValid(_ password : String) -> Bool {
        // (?=.*[A-Z]) Ensures string has one capital letter.
        // (?=.[$@$#!%?&]) - Ensures string has one special character.
        // {8,} - Ensures password length is 8.
        // $ - Ends Anchor.
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
    
    //Generates a random number from 0 till max of int.
    static func genRandomNumber() -> Int {
        return Int.random(in: 0 ... Int.max)
    }
    
}
