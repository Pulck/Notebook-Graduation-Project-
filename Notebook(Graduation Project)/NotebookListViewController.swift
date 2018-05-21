//
//  TotalNotebooksViewController.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/3/6.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit
import CoreData

class NotebookListViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var notebookHeaderView: UIView!
    
    lazy var fetchedResultController: NSFetchedResultsController<Notebook> = {
        let context = AppDelegate.viewContext
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest(use: nil), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            controller.delegate = self
            try controller.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        return controller
    }()
    
    func fetchRequest(use predicate: NSPredicate?) -> NSFetchRequest<Notebook> {
        let fetchRequest: NSFetchRequest<Notebook> = Notebook.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true,  selector: #selector(NSString.localizedCompare(_:)))]
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    
    var lastIndexPath: IndexPath {
        let numberOfRow = fetchedResultController.sections?.first?.numberOfObjects ?? 1
        return IndexPath(row: numberOfRow, section: 1)
    }
    
    var allNoteIndexPath = IndexPath(row: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchedResultController.sections?.count ?? 0) + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return (fetchedResultController.sections?.first?.numberOfObjects ?? 0) + 1
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Notebook Cell", for: indexPath)
        
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        if let noteCell = cell as? NotebookCell {
            if indexPath.section == 0 {
                noteCell.notebookImageView?.image = #imageLiteral(resourceName: "Note")
                noteCell.noteTitle.text = NSLocalizedString("All Notes", comment: "所有笔记")
                noteCell.separatorLine.isHidden = true
                
                request.predicate = NSPredicate(format: "isInTrash = NO")
                let count = (try? AppDelegate.viewContext.count(for: request)) ?? 0
                noteCell.noteCount.text = "(\(count))"
            } else if indexPath.section == 1 {
                if indexPath == lastIndexPath {
                    noteCell.notebookImageView?.image = #imageLiteral(resourceName: "Trash")
                    noteCell.noteTitle.text = NSLocalizedString("Trash", comment: "回收站")
                    noteCell.separatorLine.isHidden = true
                    
                    request.predicate = NSPredicate(format: "isInTrash = YES")
                    let count = (try? AppDelegate.viewContext.count(for: request)) ?? 0
                    noteCell.noteCount.text = "(\(count))"
                } else {
                    let indexPath = IndexPath(row: indexPath.row, section: indexPath.section - 1)
                    noteCell.notebookImageView?.image = #imageLiteral(resourceName: "Notebook")
                    let notebookData = fetchedResultController.object(at: indexPath)
                    noteCell.noteTitle.text = notebookData.name
                    noteCell.separatorLine.isHidden = false
                    noteCell.noteCount.text = "(\(notebookData.count))"
                }
            }
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
    
    //左滑按钮
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Setting") { [weak self] (action, view, vertify) in
            if let nvc = UIStoryboard(name: "NotebookSettings", bundle: nil).instantiateInitialViewController() as? UINavigationController, let vc = nvc.topViewController as? NotebookSettingsController  {
                let indexPath = IndexPath(row: indexPath.row, section: indexPath.section - 1)
                vc.notebook = self?.fetchedResultController.object(at: indexPath)
                self?.present(nvc, animated: true, completion: nil)
            }
            self?.setEditing(false, animated: true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Select Notebook", let notesVC = segue.destination as? NoteListViewController {
            let indexPath = IndexPath(row: selectedIndexpath.row, section: selectedIndexpath.section - 1)

            var title: String
            var listType: ListType?
            
            if selectedIndexpath.section == 0 {
                title = NSLocalizedString("All Notes", comment: "所有笔记")
                listType = .allNote
            } else if selectedIndexpath.row == lastIndexPath.row {
                title = NSLocalizedString("Trash", comment: "回收站")
                listType = .trash
            } else {
                title = fetchedResultController.object(at: indexPath).name!
                listType = .note
            }
            
            notesVC.listType = listType
            notesVC.notebookName = title
        }
    }
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue) {
        
    }
}

//MARK: - Search Bar Delegate
extension NotebookListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var predicate: NSPredicate?
        let text = searchText.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        if text.isEmpty {
            predicate = nil
        } else {
            predicate = NSPredicate(format: "name contains[c] %@", text)
        }
        
        fetchedResultController.setValue(fetchRequest(use: predicate), forKey: "fetchRequest")
        do {
            try fetchedResultController.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        fetchedResultController.setValue(fetchRequest(use: nil), forKey: "fetchRequest")
        do {
            try fetchedResultController.performFetch()
            tableView.reloadData()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
}

//MARK: - Fetched Results Controller Delegate
extension NotebookListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            if newIndexPath != nil {
                let newIndexPath = IndexPath(row: newIndexPath!.row, section: newIndexPath!.section + 1)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if indexPath != nil {
                let indexPath = IndexPath(row: indexPath!.row, section: indexPath!.section + 1)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if indexPath != nil {
                let indexPath = IndexPath(row: newIndexPath!.row, section: newIndexPath!.section + 1)
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
        tableView.reloadRows(at: [allNoteIndexPath], with: .fade)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        tableView.reloadRows(at: [lastIndexPath], with: .fade)
    }
    
}
