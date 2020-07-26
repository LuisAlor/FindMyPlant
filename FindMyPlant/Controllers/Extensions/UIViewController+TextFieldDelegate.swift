//
//  UIViewController+TextFieldDelegate.swift
//  FindMyPlant
//
//  Created by Luis Angel Vazquez Alor on 25.07.2020.
//  Copyright © 2020 Luis Angel Vazquez Alor. All rights reserved.
//

import UIKit

extension UIViewController: UITextFieldDelegate{
    //MARK: textFieldShouldReturn: Dismiss keyboard if return was pressed
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
