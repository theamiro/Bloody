//
//  RegEx.swift
//  Donor
//
//  Created by Michael Amiro on 22/01/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import Foundation

class RegEx {
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let phoneNumber = "([+][0-9]{1,3}|0)[ ]?[0-9]{3}[ ]?[0-9]{3}[ ]?[0-9]{3}"
    static let pin = "[0-9]{4}"
    static let alphaNumeric = ".*"//"[A-Z0-9](?:[a-zA-Z0-9]|[ ](?![ ])|'(?!')|-(?!'))*" //"([a-zA-Z0-9]+[\\s]*[a-zA-Z0-9]+[\\s]*)+"
    static let alphabetic = "[a-zA-Z]*(\\s)*"
    static let numeric = "(\\d+\\.?\\d*)|([0-9]*)"//This will handle decimals //"[0-9]*"//this will handle integers
    static let date = "[0-9]{2}[/][0-9]{2}[/][0-9]{4}"
}
