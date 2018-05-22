//
//  AppearOptionsViewController.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/2/27.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class AppearOptionsViewController: UIViewController {

    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var optionsPane: UIView!
    var height: NSLayoutConstraint!
    
    weak var window: AppearOptionsWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        height = coverView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0 / 3, constant: 0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(resignOptionsPane))
        coverView.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentOptionsPane()
    }
    
    @IBAction func closeButtonClick(_ sender: UIButton) {
        resignOptionsPane()
    }
    
    func presentOptionsPane() {
        height.isActive = true//测试弹出动画需要取消注释
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
            self.coverView.alpha = 0.3
            self.view.layoutIfNeeded()//测试弹出动画需要取消注释
        }, completion: nil)
    }
    
    @objc func resignOptionsPane() {
        let window = UIApplication.shared.delegate?.window!
        height.isActive = false
        UIView.animate(withDuration: 0.2, animations: {
            self.coverView.alpha = 0.0
            self.view.layoutIfNeeded()//测试弹出动画需要取消注释
        }) { (finished) in
            if finished {
                window?.makeKeyAndVisible()
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Container segue", let paneVC = segue.destination as? AppearOptionsPaneViewController {
            paneVC.totalNote = window.totalNote
        }
    }
    
    deinit {
        print("appear otpions view controller has deinit")
    }

}
