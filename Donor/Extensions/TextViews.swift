//
//  TextViews.swift
//  Donor
//
//  Created by Michael Amiro on 22/01/2020.
//  Copyright © 2020 Michael Amiro. All rights reserved.
//

import Foundation
import UIKit

class TextViews: UITextView, UITextViewDelegate {
    var leftBorder = UIView()
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NSObject.self.initialize()
        initializeTextViewLook()
    }
    
    private func initializeTextViewLook(){
        self.textContainerInset = UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 25)
        let bgView = UIView(frame: CGRect(x: bounds.origin.x, y: bounds.origin.y + 110, width: 5, height: bounds.height))
        bgView.tag = 5678
        bgView.backgroundColor = ColorValues.accentColor
        bgView.alpha = 0
        self.addSubview(bgView)
    }
    
    func highlightTextView(state: Bool, withMessage message: String?) {
        let bgView = self.subviews.first { (view) -> Bool in
            view.tag == 5678
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
}

//private func initializeFieldLook(){
//    self.textColor = ColorValues.accentColor
//    self.borderStyle = .none
//    self.backgroundColor = UIColor.systemBackground
//    self.placeholderFontScale = 1.0
//    self.placeholderColor = ColorValues.mutedColor
//    let bgView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5, height: bounds.height))
//    bgView.tag = 1234
//    bgView.backgroundColor = ColorValues.accentColor
//    bgView.alpha = 0
//    self.addSubview(bgView)
//}


//setup border
//       self.translatesAutoresizingMaskIntoConstraints = false
//       leftBorder = UIView.init(frame: CGRect(x: bounds.origin.x, y: bounds.origin.y + 110, width: 5, height: bounds.height))
//       leftBorder.backgroundColor = .red
//       leftBorder.translatesAutoresizingMaskIntoConstraints = false
//       self.superview!.addSubview(leftBorder)
