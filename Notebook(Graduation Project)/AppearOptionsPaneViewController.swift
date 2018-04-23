//
//  AppearOptionsPaneViewController.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/2/28.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class AppearOptionsPaneViewController: UITableViewController {

    @IBOutlet var appearModebuttons: [UIButton]!
    @IBOutlet var previewOptions: [UITableViewCell]!
    @IBOutlet var sortOptions: [UITableViewCell]!
    
    weak var totalNote: NoteListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var tag = 1
        switch totalNote.appearModeIndicator.appearMode {
        case .small:
            tag = 0
        case .normal:
            tag = 1
        case .large:
            tag = 2
        }
        appearModebuttons[tag].backgroundColor = UIColor.green
    }
    
    @IBAction func appearModeSelect(_ sender: UIButton) {
        changeAppearModeSelected(sender: sender)
    }
    
    func changeAppearModeSelected(sender: UIButton) {
        sender.backgroundColor = UIColor.green
        for button in appearModebuttons {
            if button != sender && button.backgroundColor != UIColor.cyan {
                button.backgroundColor = UIColor.cyan
            }
        }
        updateImageAppearMode(sender: sender)
    }
    
    ///通过主window经过navigation Controller接触total notes view Controller，用来更改显示模式，耦合太高，需要修改
    func updateImageAppearMode(sender: UIButton) {
        var mode = ImageAppearMode.normal
        switch sender.tag {
        case 0:
            mode = .small
        case 1:
            mode = .normal
        case 2:
            mode = .large
        default:
            preconditionFailure("Illegal button tag!")
        }
        totalNote.appearModeIndicator.appearMode = mode
        totalNote.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section + 1
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let cell = previewOptions[indexPath.row]
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else if indexPath.section == 2 {
            for (index, cell) in sortOptions.enumerated() {
                if indexPath.row != index {
                    cell.accessoryType = .none
                } else {
                    cell.accessoryType = .checkmark
                }
            }
        }
    }

    deinit {
        print("pane has deinited")
    }
}
