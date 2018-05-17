//
//  SelectNotebookViewController.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/4/26.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit
import CoreData

class SelectNotebookViewController: UITableViewController {

    lazy var fetchedResultController: NSFetchedResultsController<Notebook> = {
        let context = AppDelegate.viewContext
        let fetchRequest: NSFetchRequest<Notebook> = Notebook.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true,  selector: #selector(NSString.localizedCompare(_:)))]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            controller.delegate = self
            try controller.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        return controller
    }()
    
    var noteData: Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !shouleHideCancelButton {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        }
    }
    
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }

    var shouleHideCancelButton = false

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController.sections?.first?.numberOfObjects ?? 0
    }
    
    var selectedIndexPath: IndexPath!
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Notebook Cell", for: indexPath)
        let data = fetchedResultController.object(at: indexPath)
        if data.name == noteData.notebook?.name {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
        }
        cell.textLabel?.text = data.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath != selectedIndexPath {
            noteData.notebook?.count -= 1
            noteData.notebook = fetchedResultController.object(at: indexPath)
            noteData.notebook!.count += 1
        }
        dismiss(animated: true, completion: nil)
    }

}

//MARK: - Fetched Results Controller Delegate
extension SelectNotebookViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        default:
            break;
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

