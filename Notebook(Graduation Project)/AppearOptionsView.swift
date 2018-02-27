//
//  AppearOptionsView.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/2/27.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class AppearOptionsView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func back(_ sender: UIButton) {
        let window = UIApplication.shared.delegate?.window!
        window?.makeKeyAndVisible()
    }
    
}
