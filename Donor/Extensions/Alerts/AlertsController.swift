//
//  Alerts.swift
//  Donor
//
//  Created by Michael Amiro on 22/01/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

class AlertsController {
    let alertNoButtonStyle = SCLAlertView.SCLAppearance(
        kWindowWidth: 300.0,
        kTitleFont: UIFont(name: "AvenirNext-DemiBold", size: 22)!,
        kTextFont: UIFont(name: "AvenirNext-Medium", size: 14)!,
        kButtonFont: UIFont(name: "AvenirNext-Medium", size: 16)!,
        showCloseButton: false,
        showCircularIcon: false,
        contentViewCornerRadius : 10.0,
        fieldCornerRadius: 4.0,
        buttonCornerRadius: 4.0,
        contentViewColor: .systemBackground,
        contentViewBorderColor: .systemBackground
    )
    
    func generateAlert(withError errorMessage: String) {
        let alert = SCLAlertView(appearance: self.alertNoButtonStyle)
        alert.addButton("dismiss", backgroundColor: UIColor.red, textColor: .white, showTimeout: nil) {}
        alert.showError("There's a problem", subTitle: errorMessage, closeButtonTitle: nil, timeout: nil, colorStyle: 0x050F50, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .noAnimation)
    }
    
    func generateAlert(withSuccess successMessage: String, andTitle titleMessage: String = "Success"){
        let alert = SCLAlertView(appearance: self.alertNoButtonStyle)
        alert.addButton("dismiss", backgroundColor: ColorValues.accentColor, textColor: .white, showTimeout: nil) {}
        alert.showError(titleMessage, subTitle: successMessage, closeButtonTitle: nil, timeout: nil, colorStyle: 0x050F50, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .bottomToTop)
    }
}
