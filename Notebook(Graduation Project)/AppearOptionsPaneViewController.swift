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
    
    weak var totalNote: TotalNote!
    
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
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section + 1
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {
        print("pane has deinited")
    }
}
