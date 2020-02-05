//
//  TextFields.swift
//  Donor
//
//  Created by Michael Amiro on 21/01/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import UIKit
import TextFieldEffects

extension HoshiTextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.initializeFieldLook()
    }
    
    private func initializeFieldLook(){
        self.textColor = ColorValues.accentColor
        self.borderStyle = .none
        self.backgroundColor = UIColor.systemBackground
        self.placeholderFontScale = 1.0
        self.placeholderColor = ColorValues.mutedColor
        
        let bgView = UIView(frame: CGRect(x: 0.0, y: 50.0, width: bounds.width, height: 5.0))
        bgView.tag = 1234
        bgView.backgroundColor = ColorValues.accentColor
        bgView.alpha = 0
        self.addSubview(bgView)
    }
    
    func highlightTextField(state: Bool, withMessage message: String?) {
        let bgView = self.subviews.first { (view) -> Bool in
            view.tag == 1234
        }
        if state {
            self.textColor = UIColor.red
            bgView?.backgroundColor = UIColor.red
            bgView?.alpha = 1
        } else {
            self.textColor = ColorValues.accentColor
            bgView?.backgroundColor = ColorValues.accentColor
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        for item in self.subviews {
            if item.tag == 1234 && !self.isEditing {
                if item.alpha == 1 {
                    UIView.animate(withDuration: 0.3) {
                        item.alpha = 0
                    }
                }
            }
        }
        return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        for item in self.subviews {
            if item.tag == 1234 && self.isEditing {
                if item.alpha == 0 {
                    UIView.animate(withDuration: 0.3) {
                        item.alpha = 1
                    }
                }
            }
        }
        return CGRect(x: bounds.origin.x, y: bounds.origin.y + 10, width: bounds.width, height: bounds.height)
    }

    override open func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x, y: bounds.origin.y + 10, width: bounds.width, height: bounds.height)
    }
}
