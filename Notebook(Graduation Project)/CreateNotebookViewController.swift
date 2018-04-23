//
//  CreateNotebookViewController.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/4/23.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit
import CoreData

class CreateNotebookViewController: UIViewController {

    let context = AppDelegate.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBAction func doneButtonClick(_ sender: UIBarButtonItem) {
        if let text = textField.text, !text.isEmpty {
            let request: NSFetchRequest<Notebook>  = Notebook.fetchRequest()
            let predicate = NSPredicate(format: "name = %@", text)
            request.predicate = predicate
            let count = (try? context.count(for: request)) ?? 0
            if count == 0 {
                do {
                    let notebook = Notebook(context: context)
                    notebook.count = 0
                    notebook.name = text
                    notebook.createdDate = Date()
                    try context.save()
                    dismiss(animated: true, completion: nil)
                } catch {
                    let alter = UIAlertController(title: "Core Data", message: "Save Failure", preferredStyle: .alert)
                    present(alter, animated: true, completion: nil)
                    context.rollback()
                }
            } else {
                let alter = UIAlertController(title: "Core Data", message: "Had Created", preferredStyle: .alert)
                present(alter, animated: true, completion: nil)
            }
        }
    }
    
}
