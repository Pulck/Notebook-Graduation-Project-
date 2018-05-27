//
//  TabBarController.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/3/10.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        if viewController.title == "Add Controller" {
            return false
        }
        return true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let title = item.title, title.isEmpty else {
            return
        }
        
        self.addNote()
    }
    
    func addNote() {
        let noteEditVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Edit Note") as! NoteEditViewController
        let navigationController = UINavigationController(rootViewController: noteEditVC)
        let doneString = NSLocalizedString("Done", comment: "完成")
        let cancelString = NSLocalizedString("Cancel", comment: "取消")
        noteEditVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: doneString, style: .done, target: noteEditVC, action: #selector(noteEditVC.backAndSave))
        noteEditVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: cancelString, style: .plain, target: noteEditVC, action: #selector(noteEditVC.backAndDelete))
        noteEditVC.noteData = nil
        noteEditVC.initialEditableState = true
        present(navigationController, animated: true, completion: nil)
    }
    
}

