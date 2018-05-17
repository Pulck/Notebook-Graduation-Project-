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
        noteEditVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: noteEditVC, action: #selector(noteEditVC.back))
        noteEditVC.noteData = nil
        present(navigationController, animated: true, completion: nil)
    }
    
}

