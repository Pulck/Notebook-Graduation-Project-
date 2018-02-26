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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchArea: UIStackView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var buttonArea: UIStackView!
    
    private lazy var dummyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.3
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //动态计算cell的高度
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.groupTableViewBackground
        
//        let searchResultController = UIStoryboard(name: "NoteContentSearchController", bundle: nil).instantiateViewController(withIdentifier: "Search Controller")
//        searchController = UISearchController(searchResultsController: searchResultController)
//        searchResultController.definesPresentationContext = true
//        tableView.tableHeaderView = searchController.searchBar
        
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
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Plain Text", for: indexPath)
        if let plainTextCell = cell as? PlainTextCell {
            
            plainTextCell.noteDateLabel.text = "1995/7/11"
            plainTextCell.noteTitleLabel.text = "标题"
            plainTextCell.noteTextLabel.text = "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"
            plainTextCell.noteImages = [#imageLiteral(resourceName: "TestImage1"), #imageLiteral(resourceName: "TestImage2")]
            plainTextCell.appearMode = .small
            plainTextCell.appearMode = .large
            plainTextCell.appearMode = .normal

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

    @IBAction func noteButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func notificationButtonClick(_ sender: UIButton) {
        if sender.currentImage == #imageLiteral(resourceName: "notificationIcon") {
            sender.setImage(#imageLiteral(resourceName: "notification_selected"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "notificationIcon"), for: .normal)
        }
    }
    
    
}

extension TotalNote: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        self.view.addSubview(dummyView)
        self.tableView.isScrollEnabled = false
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        dummyView.topAnchor.constraint(equalTo: searchView.bottomAnchor).isActive = true
        dummyView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        dummyView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        dummyView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        buttonArea.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dummyView.removeFromSuperview()
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        tableView.isScrollEnabled = true
        buttonArea.isHidden = false
    }
}
