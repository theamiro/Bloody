//
//  AuthenticationServicesViewController.swift
//  Donor
//
//  Created by Michael Amiro on 03/02/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices
//import Lottie
import TextFieldEffects

class AuthenticationServicesViewController: UIViewController {
    
    @IBOutlet weak var GIDSignInButton: UIButton!
    @IBOutlet weak var signInButtonStack: UIStackView!
    @IBOutlet weak var continueWithPhoneButton: UIButton!
    //    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var phoneNumberField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signInButtonStack.alpha = 0
        animation()
        setUpSignInAppleButton()
        setUpSignInGoogleButton()
    }
    
    func animation(){
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseIn, animations: {
            self.signInButtonStack.alpha = 1
        }) { (animated) in
            print("animated successfully")
        }
//        animationView.play{(finished) in
//
//
//        }
    }
    
    @IBAction func continueWithPhoneNumber(_ sender: Any) {
        continueWithPhoneButton.setTitle("Requesting code...", for: .normal)
        requestVerificationCode()
    }
    
    func setUpSignInAppleButton() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.frame = CGRect(x: 0, y: 0, width: 200, height: 46)
        authorizationButton.cornerRadius = 23.0
        //Add button on some view or stack
        self.signInButtonStack.insertArrangedSubview(authorizationButton, at: 0)
        authorizationButton.heightAnchor.constraint(equalToConstant: 46.0).isActive = true
    }
    
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self as? ASAuthorizationControllerDelegate
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
    }
    
    // MARK; Google Sign in
    func setUpSignInGoogleButton(){
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().restorePreviousSignIn()
        GIDSignInButton.layer.borderWidth = 1
        GIDSignInButton.layer.borderColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        GIDSignInButton.layer.cornerRadius = 23.0
    }
    
    //    MARK: Google Signin
    @IBAction func GIDSignInButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    func signInWillDispatch(_ signIn: GIDSignIn!, error: Error!) {
        
    }
    func signIn(_ signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    func signIn(_ signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func requestVerificationCode(){
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberField.text!, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                AlertsController().generateAlert(withError: error.localizedDescription)
                self.continueWithPhoneButton.setTitle("Continue", for: .normal)
                return
            }
            // Go to verification
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.performSegue(withIdentifier: "verify", sender: Any?.self)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
