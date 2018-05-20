//
//  File.swift
//  Notebook(Graduation Project)
//
//  Created by Colick on 2018/5/20.
//  Copyright © 2018年 The Big Nerd. All rights reserved.
//

import Foundation

struct ListOptionsKey {
    static let appearMode = "list.appearMode"
    static let isDisplayImage = "list.isDisplayImage"
    static let isDisplayBodyContent = "list.isDisplayBodyContent"
    static let sortOptions = "list.sortOptions"
}

enum ListAppearMode: Int {
    case samll
    case media
    case large
}

enum ListSortOption: Int {
    case updatedDate
    case createdData
    case noteTitle
}
