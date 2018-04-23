//
//  FontSettingViewController.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/4/17.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class FontSettingView: UIView {
    weak var delegate: FontSettingDelegate?

    @IBAction func styleSettingButtonClick(_ sender: UIButton) {
        var style: String?
        switch sender.tag {
        case 0:
            style = FontStyle.bold.rawValue
        case 1:
            style = FontStyle.italic.rawValue
        case 2:
            style = FontStyle.underLine.rawValue
        case 3:
            style = FontStyle.comment.rawValue
        default:
            preconditionFailure()
        }
        
        guard let defineStyle = style else {
            return
        }
        
        delegate?.fontStyleButtonClick?(sender, style: defineStyle)
    }
    
    var lastSelectedSizeButton: UIButton?
    @IBAction func sizeSettingButtonClick(_ sender: UIButton) {
        var size: Int?
        switch sender.tag {
        case 0:
            size = FontSize.small.rawValue
        case 1:
            size = FontSize.middle.rawValue
        case 2:
            size = FontSize.large.rawValue
        default:
            preconditionFailure()
        }
        
        guard let defineSize = size else {
            return
        }
        
        lastSelectedSizeButton?.isSelected = false
        sender.isSelected = true
        lastSelectedSizeButton = sender
        delegate?.fontSizeButtonClick?(size: defineSize)
    }
    

}

@objc
protocol FontSettingDelegate {
    @objc optional func fontStyleButtonClick(_ sender: UIButton, style: String);
    @objc optional func fontSizeButtonClick(size: Int);
    @objc optional func fontColorButtonClick(color: UIColor);
}

enum FontStyle: String {
    case bold = "Bold"
    case italic = "Oblique"
    case underLine
    case comment
}

enum FontSize: Int {
    case small = 12
    case middle = 18
    case large = 24
}
