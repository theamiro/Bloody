//
//  Validation.swift
//  Donor
//
//  Created by Michael Amiro on 22/01/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects

enum validationType {
    case email
    case phoneNumber
    case pin
    case alphaNumeric
    case alphabetic
    case numeric
    case date
    case none
}

extension HoshiTextField {
    func validateField(type: validationType, customError: String?) -> (Bool) {
        if self.text != nil && self.text! != "" {
            let (state, message) = ValidationCheck().validate(content: self.text!, type: type)
            if state {
                self.highlightTextField(state: false, withMessage: nil)
            } else {
                self.highlightTextField(state: true, withMessage: message)
            }
            return(state)
        } else {
            var message = ""
            if customError != nil {
                message = customError!
            } else {
                message = ErrorMessage.missingData
            }
            self.highlightTextField(state: true, withMessage: message)
            return(false)
        }
    }
    
    
}

class ValidationCheck {
    func validate(content: String, type: validationType) -> (Bool, String){
        var checkData = content
        var regEx: String = ""
        var errorMessage: String = ""
        if type == .email {
            checkData = content.replacingOccurrences(of: " ", with: "")
            regEx = RegEx.email
            errorMessage = ErrorMessage.validationEmail
        } else if type == .phoneNumber {
            checkData = content.replacingOccurrences(of: " ", with: "")
            regEx = RegEx.phoneNumber
            errorMessage = ErrorMessage.validationPhoneNumber
        } else if type == .pin {
            regEx = RegEx.pin
            errorMessage = ErrorMessage.validationPin
        } else if type == .alphaNumeric {
            regEx = RegEx.alphaNumeric
            errorMessage = ErrorMessage.validationAlphaNumeric
        } else if type == .alphabetic {
            regEx = RegEx.alphabetic
            errorMessage = ErrorMessage.validationAlphabetic
        } else if type == .numeric {
            regEx = RegEx.numeric
            errorMessage = ErrorMessage.validationNumeric
        } else if type == .date {
            regEx = RegEx.date
            errorMessage = ErrorMessage.validationDate
        } else if type == .none {
            return(true, ErrorMessage.success)
        } else {
            return(false, "please enter a valid validation type")
        }
        let check = NSPredicate(format:"SELF MATCHES[c] %@", "^\(regEx)$")
        let state = check.evaluate(with: checkData)
        if state {
            return(true, ErrorMessage.success)
        } else {
            print("VALIDATION ERROR: ", errorMessage)
            return(false, errorMessage)
        }
    }
}
