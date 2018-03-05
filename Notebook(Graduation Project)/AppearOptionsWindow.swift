//
//  AppearOptionsWindow.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/3/5.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import UIKit

class AppearOptionsWindow: UIWindow {
    weak var totalNote: TotalNote!
    
    //覆盖用来在切换window时，保证选项面板的弹出动画正常播放
    override func makeKeyAndVisible() {
        super.makeKeyAndVisible()
        guard let vc = rootViewController as? AppearOptionsViewController else {
            return
        }
        vc.presentOptionsPane()
    }
    
    deinit {
        print("window has deinited!")
    }
}
