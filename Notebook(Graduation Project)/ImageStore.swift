//
//  ImageStore.swift
//  Homepwner
//
//  Created by Colick on 2017/11/10.
//  Copyright © 2017年 The Big Nerd. All rights reserved.
//

import Foundation
import UIKit

struct ImageStore {
    private(set) var cache = NSCache<NSString, UIImage>()
    
    mutating func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        let url = imageURL(forKey: key)
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            try? data.write(to: url, options: [.atomic])
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        let path = imageURL(forKey: key).path
        guard let imageFromDisk = UIImage(contentsOfFile: path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    mutating func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
        
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(key)
    }
}
