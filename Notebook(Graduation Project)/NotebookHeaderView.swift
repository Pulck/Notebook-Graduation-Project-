//
//  NotebookHeaderView.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/3/6.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class NotebookHeaderView: UIView {

    var delegate: NoteBookHeaderDelegate?
    
    @IBOutlet weak var title: UILabel!
    
    @IBAction func addButtonClick(_ sender: UIButton) {
        delegate?.addButtonDidClick(sender)
    }
    
}

protocol NoteBookHeaderDelegate {
    func addButtonDidClick(_ sender: UIButton)
}
