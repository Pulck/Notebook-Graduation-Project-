//
//  TotalNote.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/2/23.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class NoteListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchArea: UIStackView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var buttonArea: UIStackView!
    
    let context = AppDelegate.viewContext
    let appearModeIndicator = ImageAppearModeIndicator()
    
    private lazy var dummyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //动态计算cell的高度
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.groupTableViewBackground
        
        //添加dummy视图，用于在键盘弹出后遮挡tableview
        self.view.addSubview(dummyView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endSearch))
        dummyView.addGestureRecognizer(tapGesture)
        dummyView.isHidden = true
        dummyView.translatesAutoresizingMaskIntoConstraints = false
        dummyView.topAnchor.constraint(equalTo: searchView.bottomAnchor).isActive = true
        dummyView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        dummyView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        dummyView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func startSearch() {
        buttonArea.isHidden = true
        searchBar.setShowsCancelButton(true, animated: true)

        dummyView.isHidden = false
        tableView.isScrollEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.dummyView.alpha = 0.3
        }
    }
    
    @objc func endSearch() {
        searchBar.setShowsCancelButton(false, animated: false)
        searchBar.resignFirstResponder()
        buttonArea.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.dummyView.alpha = 0.0
        }) { (finished) in
            if finished {
                self.dummyView.isHidden = true
                self.tableView.isScrollEnabled = true
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 80
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Plain Text", for: indexPath)
        
        if let plainTextCell = cell as? NotePreviewCell {
            
            plainTextCell.noteDateLabel.text = "1995/7/11"
            plainTextCell.noteTitleLabel.text = "标题"
            plainTextCell.noteTextLabel.text = "内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容内容"
            plainTextCell.noteImages = [#imageLiteral(resourceName: "TestImage1"), #imageLiteral(resourceName: "TestImage2"), #imageLiteral(resourceName: "TestImage3")]
            plainTextCell.appearModeIndicator = appearModeIndicator

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
    
    lazy var window: AppearOptionsWindow! = {
        let application =  UIApplication.shared
        let window = AppearOptionsWindow(frame: application.keyWindow!.frame)
        
        let viewController = UIStoryboard(name: "AppearOptions", bundle: Bundle.main).instantiateInitialViewController() as! AppearOptionsViewController
        
        /*window在此处对AppearOptionsViewController、totalNote即self都产生了强引用；与此同时AppearOptionsViewController对window也产生了强引用，形成了强引用循环，此处在AppearOptionsViewController中将对window的引用改为weak；window是totalNote这个self中的属性，所以self引用window，window引用self，循环再次产生，此处将window中的对totalNote的引用改为weak；综上所有此处产生的循环强引用得到了解决
         */
        window.rootViewController = viewController
        viewController.window = window
        window.totalNote = self
        return window
    }()
    
    var listType: ListType?
    @IBAction func optionButtonClick(_ sender: UIBarButtonItem) {
        guard let type = listType else {
            return
        }
        
        switch type {
        case .note:
            presentAppearOptionsWindow()
        case .notebook, .trash:
            presentOptionsSheet()
        }
    }
    
    func presentAppearOptionsWindow() {
        window.makeKeyAndVisible()
    }
    
    func presentOptionsSheet() {
        assert(listType != .note, "Illegal list type!")
        
        let alterController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet
        )
        
        let appearOptionsAction = UIAlertAction(title: "Appear Options", style: .default) { (action) in
            self.presentAppearOptionsWindow()
        }
        alterController.addAction(appearOptionsAction)
        
        if listType == .trash {
            let removeAction = UIAlertAction(title: "Remove All", style: .default) { (action) in
                
            }
            alterController.addAction(removeAction)
        } else {
            let notebookOptionsAction = UIAlertAction(title: "Notebook Options", style: .default) { (action) in
                
            }
            alterController.addAction(notebookOptionsAction)
        }
        
        let addShortcutAction = UIAlertAction(title: "Add To Shortcut", style: .default, handler: nil)
        alterController.addAction(addShortcutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alterController.addAction(cancelAction)
        
        present(alterController, animated: true, completion: nil)
    }
    
    
    deinit {
        print("total note has deinited")
    }
}


extension NoteListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        startSearch()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endSearch()
    }
}

extension NoteListViewController: NoteBookHeaderDelegate {
    
}

enum ListType {
    case note
    case notebook
    case trash
}
