//
//  TotalNote.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/2/23.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit
import Foundation

class TotalNote: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //自动计算cell的高度
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Plain Text", for: indexPath)
        if let plainTextCell = cell as? PlainTextCell {
            
            plainTextCell.noteDateLabel.text = "1995/7/11"
            plainTextCell.noteTitleLabel.text = "林腾涛"
            plainTextCell.noteTextLabel.text = "傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼傻逼"
            plainTextCell.appearMode = .small
            plainTextCell.noteImages = [#imageLiteral(resourceName: "TestImage1"), #imageLiteral(resourceName: "TestImage2")]
        }
        return cell
    }
 

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

}
