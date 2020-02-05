//
//  VerificationCodeViewController.swift
//  Donor
//
//  Created by Michael Amiro on 15/01/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import UIKit
import FirebaseAuth
import TextFieldEffects

class VerificationCodeViewController: UIViewController {
    
    var countdownTimer: Timer?
    var timeLeft = 10
    
    var userPhoneNumber: String?
    var attempts: Int?
    
    @IBOutlet weak var verifyCode: HoshiTextField!
    @IBOutlet weak var resendVerificationBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var resendVerificationButton: UIButton!
    @IBOutlet weak var resendVerificationButtonHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resendVerificationButton.alpha = 0
        verifyCode.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        
        
        self.verifyCode.addTarget(self, action: #selector(self.validateTextOnType), for: .editingChanged)
        GlobalForm().setupTextFields(formFields: [self.verifyCode], withController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.resendVerificationButton.alpha = 1
        }
    }
    
    //MARK: Timer
    @objc func countdown(){
        if timeLeft <= 0 {
            countdownTimer!.invalidate()
            resendVerificationButton.isEnabled = true
            countdownTimer = nil
            enableResendButton()
            
        }else if (timeLeft > 0) {
            let minutes = String(format: "%02d" ,timeLeft / 60)
            let seconds = String(format: "%02d" ,timeLeft % 60)
            let text = minutes + ":" + seconds
            timeLeft -= 1
            resendVerificationButton.setTitle("Resend verification in \(text)", for: .normal)
        }
    }
    
    // MARK: Keyboard Show Action
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.resendVerificationBottomConstraint.constant = keyboardHeight - 20
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        self.resendVerificationBottomConstraint.constant = 20
    }
    
    func enableResendButton(){
        resendVerificationButton.setTitle("Resend code", for: .normal)
        resendVerificationButton.setTitleColor(.white, for: .normal)
        resendVerificationButton.titleLabel?.font = FontValues.mediumFont
        resendVerificationButton.backgroundColor = ColorValues.accentColor
        resendVerificationButton.layer.cornerRadius = 23
        resendVerificationButton.addTarget(self, action: #selector(resendVerificationCode), for: .touchUpInside)
        resendVerificationButtonHeightConstraint.constant = 46
    }
    
    @IBAction func verifyCodeButton(_ sender: Any) {
        
    }
    
    
    // MARK: Resend Verification Code
    
    @objc func resendVerificationCode(){
        // todo: implement the fallback
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @objc func validateTextOnType(){
        if self.verifyCode.text!.count == 6 {
            self.verifyCode.resignFirstResponder()
            countdownTimer?.invalidate()
            resendVerificationButton.isHidden = true
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verifyCode.text!)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    AlertsController().generateAlert(withError: error.localizedDescription)
                    return
                }
                UserDefaults.standard.set(true, forKey: "loggedIn")
                self.performSegue(withIdentifier: "setupProfile", sender: Any?.self)
            }
        }
    }
}
