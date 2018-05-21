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
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        let trimText = text.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        if !trimText.isEmpty {
            let request: NSFetchRequest<Notebook>  = Notebook.fetchRequest()
            let predicate = NSPredicate(format: "name = %@", trimText)
            request.predicate = predicate
            let count = (try? context.count(for: request)) ?? 0
            if count == 0 {
                let notebook = Notebook(context: context)
                notebook.count = 0
                notebook.name = trimText
                notebook.createdDate = Date()
                
                dismiss(animated: true, completion: nil)
            } else {
                let alter = UIAlertController(title: "Core Data", message: NSLocalizedString("Had Created", comment: "已被创建"), preferredStyle: .alert)
                alter.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: "完成"), style: .default, handler: nil))
                present(alter, animated: true, completion: nil)
            }
        }
    }
    
}
