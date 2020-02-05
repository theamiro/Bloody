//
//  ProfileViewController.swift
//  Donor
//
//  Created by Michael Amiro on 15/01/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import UIKit
import HealthKit
import TextFieldEffects
import FirebaseAuth
import FirebaseDatabase
import SCLAlertView

struct UserProfileData {
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    let phoneNumber: String
    let email: String
    let gender: String
    let bloodType: String
    let weight: String
    let height: String
}

class UserProfileDataObject {
    
    var ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    func fetchProfileData(completion: @escaping (Bool, UserProfileData?)->()){
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let firstName = value?["firstName"] as? String
            let lastName = value?["lastName"] as? String
            let dateOfBirth = value?["dateOfBirth"] as? String
            let phoneNumber = value?["phoneNumber"] as? String
            let email = value?["emailAddress"] as? String
            let gender = value?["gender"] as? String
            let bloodType = value?["bloodType"] as? String
            let weight = value?["weight"] as? String
            let height = value?["height"] as? String
            
            let profileData = UserProfileData(firstName: firstName!, lastName: lastName!, dateOfBirth: dateOfBirth!, phoneNumber: phoneNumber!, email: email!, gender: gender!, bloodType: bloodType!, weight: weight!, height: height!)
            completion(true, profileData)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func editProfileData(withData data: UserProfileData, completion: @escaping(Bool, String)->()){
        let parameters: [String: Any] = [
            "emailAddress": data.email,
            "firstName": data.firstName,
            "lastName": data.lastName,
            "dateOfbirth": data.dateOfBirth,
            "phoneNumber": data.phoneNumber,
            "gender": data.gender,
            "bloodType" : data.bloodType,
            "weight": data.weight,
            "height": data.height
        ]
        
        ref.child("users").child(userID!).setValue(parameters){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                let alert = SCLAlertView(appearance: AlertsController().alertNoButtonStyle)
                alert.addButton("Dismiss", backgroundColor: ColorValues.accentColor, textColor: .white, showTimeout: nil) {}
                alert.showError("Error!", subTitle: error as! String, closeButtonTitle: nil, timeout: nil, colorStyle: 0x050F50, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .noAnimation)
            } else {
                let alert = SCLAlertView(appearance: AlertsController().alertNoButtonStyle)
                alert.addButton("Dismiss", backgroundColor: ColorValues.accentColor, textColor: .white, showTimeout: nil) {}
                alert.showSuccess("Profile Updated!", subTitle: "Profile Data saved", closeButtonTitle: nil, timeout: nil, colorStyle: 0x050F50, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .noAnimation)
            }
        }
    }
}


class ProfileViewController: UIViewController {
    
    let healthStore = HKHealthStore()
    
    @IBOutlet weak var firstNameField: HoshiTextField!
    @IBOutlet weak var lastNameField: HoshiTextField!
    @IBOutlet weak var emailAddressField: HoshiTextField!
    @IBOutlet weak var phoneNumberField: HoshiTextField!
    
    @IBOutlet weak var dateOfBirthField: HoshiTextField!
    
    @IBOutlet weak var bloodTypeField: HoshiTextField!
    @IBOutlet weak var genderField: HoshiTextField!
    
    @IBOutlet weak var weightField: HoshiTextField!
    @IBOutlet weak var heightField: HoshiTextField!
    
    @IBOutlet weak var saveChangesButton: UIButton!
    
    var currentProfileData: UserProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeButtonBehavior()
        self.initializeFormFields()
        // Do any additional setup after loading the view.
        
        UserProfileDataObject().fetchProfileData { (state, profileData) in
            if state && profileData != nil {
                self.currentProfileData = profileData!
                self.firstNameField.text = profileData!.firstName
                self.lastNameField.text = profileData!.lastName
                self.dateOfBirthField.text = profileData!.dateOfBirth
                self.phoneNumberField.text = profileData!.phoneNumber
                self.emailAddressField.text = profileData!.email
                self.bloodTypeField.text = profileData!.bloodType
                self.genderField.text = profileData!.gender
                self.weightField.text = profileData!.weight
                self.heightField.text = profileData!.height
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    private func initializeButtonBehavior(){
        self.saveChangesButton.isEnabled = false
        self.saveChangesButton.backgroundColor = ColorValues.fadedAccentColor.withAlphaComponent(0.1)
    }
    
    func initializeFormFields(){
        self.firstNameField.addTarget(self, action: #selector(self.validateTextOnType), for: .editingChanged)
        self.lastNameField.addTarget(self, action: #selector(self.validateTextOnType), for: .editingChanged)
        self.dateOfBirthField.addTarget(self, action: #selector(self.validateTextOnType), for: .editingChanged)
        self.emailAddressField.addTarget(self, action: #selector(self.validateTextOnType), for: .editingChanged)
        self.phoneNumberField.addTarget(self, action: #selector(self.validateTextOnType), for: .editingChanged)
        self.bloodTypeField.addTarget(self, action: #selector(self.validateTextOnType), for: .editingChanged)
        self.genderField.addTarget(self, action: #selector(self.validateTextOnType), for: .editingChanged)
        self.weightField.addTarget(self, action: #selector(self.validateTextOnType), for: .editingChanged)
        self.heightField.addTarget(self, action: #selector(self.validateTextOnType), for: .editingChanged)
        GlobalForm().setupTextFields(formFields: [self.firstNameField, self.lastNameField, self.dateOfBirthField, self.emailAddressField, self.phoneNumberField, self.bloodTypeField, self.genderField, self.weightField, self.heightField], withController: self)
    }
    
    @objc func validateTextOnType(){
        self.initializeButtonBehavior()
        
        if self.firstNameField.text == self.currentProfileData?.firstName && self.lastNameField.text == self.currentProfileData?.lastName && self.emailAddressField.text == self.currentProfileData?.email && self.phoneNumberField.text == self.currentProfileData?.phoneNumber && self.dateOfBirthField.text == self.currentProfileData?.dateOfBirth && self.genderField.text == self.currentProfileData?.gender && self.bloodTypeField.text == self.currentProfileData?.bloodType && self.weightField.text == self.currentProfileData?.weight && self.heightField.text == self.currentProfileData?.height{
            return
        }
        if self.firstNameField.text!.count < 2 || !self.firstNameField.validateField(type: .alphabetic, customError: ErrorMessage.missingName) {
            self.initializeButtonBehavior()
            return
        }
        if self.lastNameField.text!.count < 2 || !self.lastNameField.validateField(type: .alphabetic, customError: ErrorMessage.missingName) {
            self.initializeButtonBehavior()
            return
        }
        if self.dateOfBirthField.text!.count < 2 || !self.dateOfBirthField.validateField(type: .date, customError: ErrorMessage.missingDate) {
            self.initializeButtonBehavior()
            return
        }
        if self.emailAddressField.text!.count < 2 || !self.emailAddressField.validateField(type: .email, customError: ErrorMessage.missingEmail) {
            self.initializeButtonBehavior()
            return
        }
        if self.phoneNumberField.text!.count < 2 || !self.phoneNumberField.validateField(type: .phoneNumber, customError: ErrorMessage.missingPhoneNumber) {
            self.initializeButtonBehavior()
            return
        }
        if self.bloodTypeField.text!.count < 2 || !self.bloodTypeField.validateField(type: .alphaNumeric, customError: ErrorMessage.missingBloodType) {
            self.initializeButtonBehavior()
            return
        }
        if self.genderField.text!.count < 1 || !self.genderField.validateField(type: .alphabetic, customError: ErrorMessage.missingOrganDonor) {
            self.initializeButtonBehavior()
            return
        }
        if self.weightField.text!.count < 1 || !self.weightField.validateField(type: .numeric, customError: ErrorMessage.missingOrganDonor) {
            self.initializeButtonBehavior()
            return
        }
        if self.heightField.text!.count < 1 || !self.heightField.validateField(type: .numeric, customError: ErrorMessage.missingOrganDonor) {
            self.initializeButtonBehavior()
            return
        }
        self.saveChangesButton.isEnabled = true
        self.saveChangesButton.backgroundColor = ColorValues.accentColor
    }
    @IBAction func updateProfile(_ sender: Any) {
        let userData = UserProfileData(firstName: self.firstNameField.text!, lastName: self.lastNameField.text!, dateOfBirth: self.dateOfBirthField.text!, phoneNumber: self.phoneNumberField.text!, email: self.emailAddressField.text!, gender: genderField.text!, bloodType: bloodTypeField.text!, weight: weightField.text!, height: heightField.text!)
        
        UserProfileDataObject().editProfileData(withData: userData) { (state, message) in
            if state {
                AlertsController().generateAlert(withSuccess: message, andTitle: "You're updated!")
            }
        }
    }
}
