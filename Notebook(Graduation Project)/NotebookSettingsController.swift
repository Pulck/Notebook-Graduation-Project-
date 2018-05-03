//
//  NotebookSettingsController.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/3/7.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit
import CoreData

class NotebookSettingsController: UITableViewController {

    var notebook: Notebook!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var shortcutSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = notebook.name
        shortcutSwitch.isOn = notebook.isShortcut
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        let alter = UIAlertController(title: "Note", message: "Delete?", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "Sure", style: .destructive) { [weak self] (action) in
            guard let notebook = self?.notebook else { fatalError("Not found notebook entity") }
            AppDelegate.viewContext.delete(notebook)
            self?.dismiss(animated: true, completion: nil)
        }
        alter.addAction(sureAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alter.addAction(cancelAction)

        present(alter, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonClick(_ sender: UIBarButtonItem) {
        if let text = nameField.text {
        let newName = text.trimmingCharacters(in: CharacterSet(charactersIn: " "))
            if !newName.isEmpty {
                notebook.name = newName
            }
        }
        
        notebook.isShortcut = shortcutSwitch.isOn
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        do {
            try AppDelegate.viewContext.save()
        } catch {
            fatalError("Save Failure: \(error)")
        }
    }
   
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if nameField.isFirstResponder {
            nameField.resignFirstResponder()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 0 else {
            return nil
        }
        
        return notebook.name
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard section == 0 else {
            return nil
        }
        
        let count = notebook.count
        if count > 1 {
            return "\(count) notes"
        } else {
            return "\(count) note"
        }
    }

}
