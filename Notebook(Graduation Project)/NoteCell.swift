//
//  NoteCell.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/5/17.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
