//
//  TotalNotebooksViewController.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/3/6.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class TotalNotebooksViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var notebookHeaderView: UIView!
    
    var data = [[1], [20]]
    var lastIndexPath: IndexPath {
        return IndexPath(row: data[1][0] - 1, section: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data[section][0]
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Notebook Cell", for: indexPath)
        
        if let noteCell = cell as? NotebookCell {
            if indexPath.section == 0 {
                noteCell.notebookImageView?.image = #imageLiteral(resourceName: "Note")
                noteCell.noteTitle.text = "All Notes"
                noteCell.separatorLine.isHidden = true
            } else if indexPath.section == 1 {
                if indexPath == lastIndexPath {
                    noteCell.notebookImageView?.image = #imageLiteral(resourceName: "Trash")
                    noteCell.noteTitle.text = "Trash"
                    noteCell.separatorLine.isHidden = true
                } else {
                    noteCell.notebookImageView?.image = #imageLiteral(resourceName: "Notebook")
                    noteCell.noteTitle.text = "Notebook"
                    noteCell.separatorLine.isHidden = false
                }
            }
            noteCell.noteCount.text = "(\(indexPath.row))"
            return noteCell
        }

        return cell
    }
 
    var selectedIndexpath: IndexPath!
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndexpath = indexPath
        searchBar.resignFirstResponder()
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return notebookHeaderView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60
        }
        return UITableViewAutomaticDimension
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 || indexPath == lastIndexPath {
            return false
        } else {
            return true
        }
    }

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
    
    //左滑按钮
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Test") { (action, view, vertify) in
//            if condition {
//                vertify(true)
//            } else {
//                vertify(false)
//            }
            if let vc = UIStoryboard(name: "NotebookSettings", bundle: nil).instantiateInitialViewController() {
                self.present(vc, animated: true, completion: nil)
            }
            self.setEditing(false, animated: true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Select Notebook", let notesVC = segue.destination as? TotalNote {
            var title: String?
            var listType: ListType?
            if selectedIndexpath.section == 0 {
                title = "All Notes"
                listType = .note
            } else if selectedIndexpath.row == data[1][0] - 1 {
                title = "Trash"
                listType = .trash
            } else {
                title = "Notebook"
                listType = .notebook
            }
            
            notesVC.title = title
            notesVC.listType = listType
        }
    }
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue) {
        
    }
}

extension TotalNotebooksViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}
