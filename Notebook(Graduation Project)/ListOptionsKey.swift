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
    static let sortOption = "list.sortOptions"
}

struct ListSortDescription {
    static var standard: ListSortDescription {
        return ListSortDescription()
    }
    
    private let updatedDate = [NSSortDescriptor(key: "modifyDate", ascending: false)]
    private let createdDate = [NSSortDescriptor(key: "createdDate", ascending: false), NSSortDescriptor(key: "modifyDate", ascending: false)]
    private let noteTitle = [NSSortDescriptor(key: "title", ascending: false, selector: #selector(NSString.localizedCompare(_:))), NSSortDescriptor(key: "modifyDate", ascending: false)]
    
    subscript(_ option: ListSortOption) -> [NSSortDescriptor] {
        switch option {
        case .createdDate:
            return createdDate
        case .updatedDate:
            return updatedDate
        case .noteTitle:
            return noteTitle
        }
    }
}


enum ListSortOption: Int {
    case updatedDate
    case createdDate
    case noteTitle
}


