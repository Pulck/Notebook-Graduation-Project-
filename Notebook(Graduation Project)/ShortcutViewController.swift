//
//  ShortcutViewController.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/3/10.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit
import CoreData

class ShortcutViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let noteRequest: NSFetchRequest<Note> = Note.fetchRequest()
        noteRequest.predicate = NSPredicate(format: "isShortcut = YES AND isInTrash = NO")
        noteRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true,  selector: #selector(NSString.localizedCompare(_:))), NSSortDescriptor(keyPath: \Note.createdDate, ascending: true)]
        noteFetchedResultsController = NSFetchedResultsController(fetchRequest: noteRequest, managedObjectContext: AppDelegate.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        noteFetchedResultsController.delegate = self
        
        
        let notebookRequest: NSFetchRequest<Notebook> = Notebook.fetchRequest()
        notebookRequest.predicate = NSPredicate(format: "isShortcut = YES")
        notebookRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true,  selector: #selector(NSString.localizedCompare(_:))), NSSortDescriptor(keyPath: \Notebook.createdDate, ascending: true)]
        notebookFetchedResultsController = NSFetchedResultsController(fetchRequest: notebookRequest, managedObjectContext: AppDelegate.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        notebookFetchedResultsController.delegate = self
        
        do {
            try notebookFetchedResultsController.performFetch()
            try noteFetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to perform fecth: \(error)")
        }
        
    }
    
    var noteFetchedResultsController: NSFetchedResultsController<Note>!
    var notebookFetchedResultsController: NSFetchedResultsController<Notebook>!
    
    func lastRow(for section: Int) -> Int {
        var row: Int = 0
        if section == 0 {
             row = (noteFetchedResultsController.fetchedObjects?.count ?? 1) - 1
        } else if section == 1 {
            row = (notebookFetchedResultsController.fetchedObjects?.count ?? 1) - 1
        }
        return row
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return noteFetchedResultsController.sections?[0].numberOfObjects ?? 0
        } else if section == 1 {
            return notebookFetchedResultsController.sections?[0].numberOfObjects ?? 0
        } else {
            fatalError("invalid section")
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "Note Cell", for: indexPath)
            let noteCell = cell as! NoteCell
            
            noteCell.titleLabel.text = noteFetchedResultsController.object(at: indexPath).title
            noteCell.separatorLine.isHidden = (indexPath.row == lastRow(for: indexPath.section))
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "Notebook Cell", for: indexPath)
            let notebookCell = cell as! NotebookCell
            
            let fixIndexPath = IndexPath(row: indexPath.row, section: 0)
            let notebookData = notebookFetchedResultsController.object(at: fixIndexPath)
            notebookCell.noteTitle.text = notebookData.name
            notebookCell.noteCount.text = "\(notebookData.count)"
            notebookCell.separatorLine.isHidden = (indexPath.row == lastRow(for: indexPath.section))
        default:
            preconditionFailure("not found shortcut type")
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        switch section {
        case 0:
            title = "Note"
        case 1:
            title = "Notebook"
        default:
            title = nil
        }
        return title
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let data: Any
        if indexPath.section == 0 {
            data = noteFetchedResultsController.object(at: indexPath)
        } else {
            let indexPath = IndexPath(row: indexPath.row, section: 0)
            data = notebookFetchedResultsController.object(at: indexPath)
        }
        
        let action = UIContextualAction(style: .normal, title: NSLocalizedString("Delete", comment: "删除")) { (action, view, vertify) in
            if indexPath.section == 0 {
                (data as! Note).isShortcut = false
            } else {
                (data as! Notebook).isShortcut = false
            }
            vertify(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    var selectedIndexPath: IndexPath!
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndexPath = IndexPath(row: indexPath.row, section: 0)
        return indexPath
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Content", let noteEditVC = segue.destination as? NoteEditViewController {
            noteEditVC.noteData = noteFetchedResultsController.object(at: selectedIndexPath)
        } else if segue.identifier == "Show Notes", let notesVC = segue.destination as? NoteListViewController {
            notesVC.listType = .note
            notesVC.notebookName = notebookFetchedResultsController.object(at: selectedIndexPath).name!
        }
    }

}

//MARK: - Fetched Results Controller Delegate
extension ShortcutViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        var section: Int
        if anObject is Notebook {
            section = 1
        } else {
            section = 0
        }
        
        switch(type) {
        case .insert:
            if newIndexPath != nil {
                let newIndexPath = IndexPath(row: newIndexPath!.row, section: section)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if indexPath != nil {
                let indexPath = IndexPath(row: indexPath!.row, section: section)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if indexPath != nil {
                let indexPath = IndexPath(row: newIndexPath!.row, section: section)
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
