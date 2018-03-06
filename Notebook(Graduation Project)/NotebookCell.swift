//
//  NotebookCell.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/3/6.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class NotebookCell: UITableViewCell {

    @IBOutlet weak var notebookImageView: UIImageView!
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
