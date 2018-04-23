//
//  CustomInputAccessoryView.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/4/14.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class CustomInputAccessoryView: UIView {
    
    weak var textView: UITextView?

    @IBAction func switchToMyInputView(_ sender: UIButton) {
        textView?.resignFirstResponder()
    }
    
    @IBAction func switchToSystemInputView(_ sender: UIButton) {
        textView?.becomeFirstResponder()
    }
    
}
