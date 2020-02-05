//
//  ErrorMessage.swift
//  Donor
//
//  Created by Michael Amiro on 22/01/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import Foundation

enum limitType {
    case minImumCharacters
    case maximumCharacters
}

enum ErrorActionType {
    case prompt
    case log
    case retry
    case logout
    case none
}

struct ErrorMessageContent {
    var message: String
    var action: ErrorActionType
    var title: String
}

class ErrorMessage {
    static let success = "success"
    static let noData = "no data found"
    
    static let parseError = "Response could not be parsed"
    static let missingDataFromResponse = "some data is missing from the response."
    
    //MARK:- Validation message
    static let invalidTitle = "Invalid data"
    static let validationPin = "Please enter a valid PIN"
    static let validationUsernameLength = "The username must be at least 8 characters long"
    static let validationYourNameLength = "Your name cannot have less than 2 characters"
    static let validationUsername = "Please enter a valid username"
    static let confirmationPinCheck = "The confirmation PIN and the PIN do not match"
    static let validationEmail = "Please enter a valid email"
    static let validationDate = "Please enter a valid date"
    static let validationPhoneNumber = "Please enter a valid phone number"
    static let validationAlphaNumeric = "Only letters and numbers can be used"
    static let validationAlphabetic = "Only letters can be used"
    static let validationNumeric = "Only numbers can be used"
    static let duplicateCard = "You have entered a duplicate card."
    static let validCard = "please enter a valid card"
    static let validAccount = "please enter a valid account"
    static let selectGender = "please select your gender"
    
    //MARK:- Missing data
    static let missingTitle = "Missing data"
    static let missingData = "required data is missing"
    static let missingUsername = "please enter a username"
    static let missingName = "please enter a name"
    static let missingIdNumber = "please enter an ID number"
    static let missingDate = "please enter a date"
    static let missingEmail = "please enter an email address"
    static let missingPin = "please enter a pin"
    static let missingPassword = "please enter a password"
    static let missingPhoneNumber = "please enter a phone number"
    static let pleaseAddMessage = "please add a message to begin chatting with a Mia® Agent"
    static let missingBloodType = "please enter your blood type"
    static let missingOrganDonor = "please state whether you are an organ donor"
    
    //MARK:- generic errors
    static let genericErrorTitle = "Error"
    static let somethingWentWrong = "someting went wrong."
    
    func textLimitError(limit: Int, fieldName: String, limitType: limitType) -> String {
        if limitType == .minImumCharacters {
            return("The \(fieldName) has to be at least \(limit) characters long")
        } else {
            return("The \(fieldName) cannot be more than \(limit) characters long")
        }
    }
}
