//
//  Form.swift
//  Donor
//
//  Created by Michael Amiro on 22/01/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects

class GlobalForm{
    func setupTextFields(formFields: [UITextField], withController rootVC: UIViewController){
        guard formFields.count > 0 else {
            return
        }
        for (index, field) in formFields.enumerated() {
            field.tag = index
            if index != (formFields.count - 1) {
                field.returnKeyType = .next
            } else {
                field.returnKeyType = .done
            }
            field.delegate = rootVC
        }
    }
}
extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            print("SHOULD GO NEXT")
        }
        return true
    }
}
