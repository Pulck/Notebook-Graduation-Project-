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
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            let localizedText = NSLocalizedString("Search in", comment: "笔记搜索框占位符")
            let placeHolder = localizedText.replacingOccurrences(of: "*", with: title ?? "")
            searchBar.placeholder = placeHolder
        }
    }
    @IBOutlet weak var searchView: UIView!
    
    let appearModeIndicator: ListAppearModeIndicator = {
        let defaults = UserDefaults.standard
        let indicator = ListAppearModeIndicator()
        
        indicator.appearMode = ListAppearMode(rawValue: defaults.integer(forKey: ListOptionsKey.appearMode))!
        indicator.isShowImage = defaults.bool(forKey: ListOptionsKey.isDisplayImage)
        indicator.isShowContentPreview = defaults.bool(forKey: ListOptionsKey.isDisplayBodyContent)
        indicator.sortOption = defaults.integer(forKey: ListOptionsKey.sortOption)
        
        return indicator
    }()
    
    let context = AppDelegate.viewContext
    var notebookName: String! {
        didSet {
            title = notebookName
            
            switch listType! {
            case .allNote:
                predicate =  NSPredicate(format: "isInTrash = NO")
            case .note:
                predicate = NSPredicate(format: "notebook.name = %@ && isInTrash = NO", notebookName)
            case .trash:
                predicate = NSPredicate(format: "isInTrash = YES")
            default:
                break
            }
            
        }
    }
    
    var originPredicate: NSPredicate!
    var predicate: NSPredicate! {
        didSet {
            let request = fetchRequest(use: predicate)
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            do {
                try fetchedResultsController.performFetch()
                tableView.reloadData()
            } catch {
                fatalError("fetched Errol: \(error)")
            }
        }
    }
    
    var sortDescriptions: [NSSortDescriptor] = {
        let option = ListSortOption(rawValue: UserDefaults.standard.integer(forKey: ListOptionsKey.sortOption))!
        return ListSortDescription.standard[option]
        }() {
        didSet {
            let currentPredicate = predicate
            predicate = currentPredicate
        }
    }
    
    func fetchRequest(use predicate: NSPredicate) -> NSFetchRequest<Note> {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = sortDescriptions
        request.predicate = predicate
        return request
    }
    
    private var fetchedResultsController: NSFetchedResultsController<Note>!
    
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
        return (fetchedResultsController.sections?.count) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController.sections?[section].numberOfObjects) ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Plain Text", for: indexPath)
        
        if let plainTextCell = cell as? NotePreviewCell {
            let note = fetchedResultsController.object(at: indexPath)
            plainTextCell.note = note
            plainTextCell.appearModeIndicator = appearModeIndicator
        }
        return cell
    }
    
    var selectedIndexPath: IndexPath!
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }
    
    //左滑按钮
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let noteData = fetchedResultsController.object(at: indexPath)
        var actions = [UIContextualAction]()
        
        let action = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "删除")) { [weak self] (action, view, completionHandler) in
            if self?.listType == .note {
                noteData.notebook!.count -= 1
                noteData.isInTrash = true
                completionHandler(true)
            } else {
                let alter = UIAlertController(title: NSLocalizedString("Note", comment: "注意"), message: NSLocalizedString("Delete?", comment: "是否删除"), preferredStyle: .alert)
                let sureAction = UIAlertAction(title: NSLocalizedString("Sure", comment: "确定"), style: .destructive) { [weak self] (action) in
                    self?.context.delete(noteData)
                    completionHandler(true)
                    
                }
                alter.addAction(sureAction)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "取消"), style: .cancel) {
                    (action) in
                    completionHandler(false)
                }
                alter.addAction(cancelAction)
                
                self?.present(alter, animated: true, completion: nil)
            }
        }
        actions.append(action)
        
        if listType == .trash {
            let restoreAction = UIContextualAction(style: .normal, title: NSLocalizedString("Restore", comment: "恢复到原位置")) { (action, view, completionHandler) in
                noteData.notebook!.count += 1
                noteData.isInTrash = false
                completionHandler(true)
            }
            actions.append(restoreAction)
        } else {
            let addToShortcutAction = UIContextualAction(style: .normal, title: "AddToShortcut") { (action, view, completionHandler) in
                noteData.isShortcut = true
                completionHandler(false)
            }
            actions.append(addToShortcutAction)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: actions)
        return configuration
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Edit Note", let noteCell = sender as? NotePreviewCell {
            let noteEditVC = segue.destination as! NoteEditViewController
            noteEditVC.noteData = noteCell.note
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return listType != .trash
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
        case .note, .allNote:
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
        
        let appearOptionsAction = UIAlertAction(title: NSLocalizedString("Appear Options", comment: "笔记列表选项"), style: .default) { (action) in
            self.presentAppearOptionsWindow()
        }
        alterController.addAction(appearOptionsAction)
        
        if listType == .trash {
            let removeAction = UIAlertAction(title: NSLocalizedString("Remove All", comment: "全部删除"), style: .default) { [unowned self] (action) in
                let alter = UIAlertController(title: NSLocalizedString("Note", comment: "注意"), message: NSLocalizedString("This will delete all notes here!", comment: "全部删除提示"), preferredStyle: .alert)
                let sureAction = UIAlertAction(title: NSLocalizedString("Sure", comment: "确定"), style: .destructive) { (action) in
                    for object in self.fetchedResultsController.sections![0].objects! {
                        self.context.delete(object as! NSManagedObject)
                    }
                }
                alter.addAction(sureAction)
                
                let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "取消"), style: .cancel, handler: nil)
                alter.addAction(cancelAction)
                
                self.present(alter, animated: true, completion: nil)
            }
            alterController.addAction(removeAction)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "取消"), style: .cancel, handler: nil)
        alterController.addAction(cancelAction)
        
        present(alterController, animated: true, completion: nil)
    }
    
    deinit {
        print("total note has deinited")
    }
}

//MARK: - Search Delegate
extension NoteListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        startSearch()
        if originPredicate == nil {
            originPredicate = predicate
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text?.trimmingCharacters(in: CharacterSet(charactersIn: " ")) ?? ""
        
        let appendPredicate = NSPredicate(format: "title contains[c] %@ OR preview contains[c] %@", text, text)
        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [originPredicate, appendPredicate])
        endSearch()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endSearch()
        predicate = originPredicate
        originPredicate = nil
        searchBar.text = ""
    }
}

enum ListType {
    case note
    case allNote
    case notebook
    case trash
}

//MARK: - Fetched Results Controller Delegate
extension NoteListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            if newIndexPath != nil {
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            }
        case .delete:
            if indexPath != nil {
                tableView.deleteRows(at: [indexPath!], with: .fade)
            }
        case .update:
            if indexPath != nil {
                tableView.reloadRows(at: [indexPath!], with: .fade)
            }
        case .move:
            if indexPath != nil && newIndexPath != nil {
                tableView.deleteRows(at: [indexPath!], with: .fade)
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
