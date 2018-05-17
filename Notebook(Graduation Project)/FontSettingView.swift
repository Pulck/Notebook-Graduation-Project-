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
    @IBOutlet weak var colorSet: UIScrollView! {
        didSet {
            colorSet.layer.cornerRadius = 6
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createColorButton()
    }
    
    func createColorButton() {
        let colors = [UIColor.black, .blue, .brown, .cyan, .darkGray, .darkText, .gray, .green, .groupTableViewBackground]
        var leading = colorSet.leadingAnchor
        let scale = 3.0 / 4 as CGFloat
        let edge = (colorSet.bounds.height * (1 - scale)) / 2
        for (index, color) in colors.enumerated() {
            let button = UIButton(type: .custom)
            button.backgroundColor = color
            button.addTarget(self, action: #selector(setColorButtonClick(_:)), for: .touchUpInside)
            
            colorSet.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
            button.heightAnchor.constraint(equalTo: colorSet.heightAnchor, multiplier: scale).isActive = true
            button.leadingAnchor.constraint(equalTo: leading, constant: 5).isActive = true
            button.topAnchor.constraint(equalTo: colorSet.topAnchor, constant: edge).isActive = true
            button.bottomAnchor.constraint(equalTo: colorSet.bottomAnchor, constant: edge).isActive = true
            
            if index == colors.count - 1 {
                button.trailingAnchor.constraint(equalTo: colorSet.trailingAnchor, constant: 5).isActive = true
            }
            button.layer.cornerRadius = colorSet.bounds.height * scale / 2
            
            leading = button.trailingAnchor
        }
    }
    
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
    @IBOutlet var sizeButtons: [UIButton]! {
        didSet {
            let index = sizeButtons.index { $0.isSelected }
            lastSelectedSizeButton = sizeButtons[index!]
        }
    }
    
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
    
    @objc func setColorButtonClick(_ sender: UIButton) {
        delegate?.fontColorButtonClick?(color: sender.backgroundColor!)
    }

}

@objc protocol FontSettingDelegate {
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
