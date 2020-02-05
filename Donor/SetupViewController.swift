//
//  SetupViewController.swift
//  Donor
//
//  Created by Michael Amiro on 22/01/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import UIKit
import CoreData
import TextFieldEffects
import HealthKit
import FirebaseAuth
import FirebaseDatabase
import SCLAlertView

class SetupViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    let userID = Auth.auth().currentUser?.uid
    
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()
    
    @IBOutlet weak var firstNameField: HoshiTextField!
    @IBOutlet weak var lastNameField: HoshiTextField!
    @IBOutlet weak var dateOfBirthField: HoshiTextField!
    @IBOutlet weak var emailAddressField: HoshiTextField!
    @IBOutlet weak var phoneNumberField: HoshiTextField!
    
    @IBOutlet weak var bloodTypeField: HoshiTextField!
    @IBOutlet weak var genderField: HoshiTextField!
    
    @IBOutlet weak var weightField: HoshiTextField!
    @IBOutlet weak var heightField: HoshiTextField!
    
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var grantAccessButton: UIButton!
    
    
    private let dataTypesToWrite: NSSet = {
        let healthKitManager = HealthKitManager.sharedInstance
        return NSSet(objects:
            healthKitManager.dateOfBirthCharacteristic!,
                     healthKitManager.biologicalSexCharacteristic!,
                     healthKitManager.bloodTypeCharacteristic!,
                     healthKitManager.weightSample!,
                     healthKitManager.heightSample!)
    }()
    private let dataTypesToRead: NSSet = {
        let healthKitManager = HealthKitManager.sharedInstance
        return NSSet(objects:
            healthKitManager.dateOfBirthCharacteristic!,
                     healthKitManager.biologicalSexCharacteristic!,
                     healthKitManager.bloodTypeCharacteristic!,
                     healthKitManager.weightSample!,
                     healthKitManager.heightSample!)
    }()
    
    private enum UserDataField: Int {
        case DateOfBirth, BiologicalSex, BloodType
        
        func data() -> (title: String, value: String?) {
            
            let healthKitManager = HealthKitManager.sharedInstance
            
            switch self {
            case .DateOfBirth:
                return ("Date of Birth:", healthKitManager.dateOfBirth)
            case .BiologicalSex:
                return ("Biological Sex:", healthKitManager.biologicalSex)
            case .BloodType:
                return ("Blood Type:", healthKitManager.bloodType)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeButtonBehavior()
        self.initializeFormFields()
        ref = Database.database().reference()
    }
    @IBAction func grantPermissionButton(_ sender: Any) {
        HealthKitManager.sharedInstance.requestHealthKitAuthorization(dataTypesToWrite: dataTypesToWrite, dataTypesToRead: dataTypesToRead, completion: { (success, error) in
            if success{
                DispatchQueue.main.async {
                    self.dateOfBirthField.text = UserDataField.DateOfBirth.data().value
                    self.genderField.text = UserDataField.BiologicalSex.data().value
                    self.bloodTypeField.text = UserDataField.BloodType.data().value
                    self.displayRecentHeight()
                    self.displayRecentWeight()
                    self.orLabel.isHidden = true
                    self.grantAccessButton.isHidden = true
                }
            }else{
                print("Sucks")
            }
        })
    }
    
    private func initializeButtonBehavior(){
        self.saveChangesButton.isEnabled = false
        self.saveChangesButton.backgroundColor = ColorValues.fadedAccentColor.withAlphaComponent(0.7)
        self.saveChangesButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
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
    @IBAction func saveChangesButton(_ sender: Any) {
        storeData()
    }
    
    @objc func validateTextOnType(){
        self.initializeButtonBehavior()
        
        //        if self.nameField.text == self.currentProfileData?.firstName && self.lastNameField.text == self.currentProfileData?.lastName && self.emailField.text == self.currentProfileData?.email && self.phoneField.text == self.currentProfileData?.phoneNumber {
        //            return
        //        }
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
        self.saveChangesButton.setTitleColor(.white, for: .normal)
        
    }
    func displayRecentHeight(){
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
            print("Height Sample Type is no longer available in HealthKit")
            return
        }
        
        HealthKitManager.getMostRecentSample(for: heightSampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print(error)
                }
                return
            }
            let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
            self.heightField.text = "\(String(format: "%.2f", heightInMeters))"
        }
    }
    func displayRecentWeight(){
        guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            print("Body Mass Sample Type is no longer available in HealthKit")
            return
        }
        
        HealthKitManager.getMostRecentSample(for: weightSampleType) { (sample, error) in
            
            guard let sample = sample else {
                
                if let error = error {
                    print(error)
                }
                return
            }
            
            let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
            self.weightField.text = "\(String(format: "%.2f", weightInKilograms))"
        }
    }
    func storeData(){
        //      MARK: Firebase Data
        self.ref.child("users").child(userID!).setValue(["firstName": firstNameField.text,
                                                          "lastName": lastNameField.text,
                                                          "emailAddress": emailAddressField.text,
                                                          "phoneNumber": phoneNumberField.text,
                                                          "dateOfBirth": dateOfBirthField.text,
                                                          "gender": genderField.text,
                                                          "bloodType": bloodTypeField.text,
                                                          "weight": weightField.text,
                                                          "height": heightField.text
        ])
        
        //      MARK: Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //   //context for accessing CoreData
        let context = appDelegate.persistentContainer.viewContext
        let user = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        user.setValue(firstNameField.text, forKey: "firstName")
        user.setValue(lastNameField.text, forKey: "lastName")
        user.setValue(emailAddressField.text, forKey: "emailAddress")
        user.setValue(phoneNumberField.text, forKey: "phoneNumber")
        user.setValue(dateOfBirthField.text, forKey: "dateOfBirth")
        user.setValue(genderField.text, forKey: "gender")
        user.setValue(bloodTypeField.text, forKey: "bloodType")
        user.setValue(weightField.text, forKey: "weight")
        user.setValue(heightField.text, forKey: "height")
        do{
            try context.save()
            let alert = SCLAlertView(appearance: AlertsController().alertNoButtonStyle)
            alert.addButton("Dismiss", backgroundColor: ColorValues.accentColor, textColor: .white, showTimeout: nil) {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "baseTabController")
                controller.modalPresentationStyle = .overFullScreen
                self.present(controller, animated: true, completion: nil)
            }
            alert.showSuccess("Profile Updated!", subTitle: "Profile Data saved", closeButtonTitle: nil, timeout: nil, colorStyle: 0x050F50, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .noAnimation)
            
        }catch{
            print("Error Saving")
        }
    }
}

