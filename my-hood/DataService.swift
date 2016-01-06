 //
//  DataService.swift
//  my-hood
//
//  Created by Paul on 06.01.16.
//  Copyright © 2016 Home. All rights reserved.
//

import Foundation
import UIKit

class DataService {
    static let instance = DataService()
    
    let KEY_POSTS_IN_STORAGE = "posts_in_storage"
    private var _loadedPosts = [Post]()
    
    var loadedPosts: [Post] {
        return _loadedPosts
    }
    
    func savePosts () {
        let postsDataBits = NSKeyedArchiver.archivedDataWithRootObject(_loadedPosts)
        NSUserDefaults.standardUserDefaults().setObject(postsDataBits, forKey: KEY_POSTS_IN_STORAGE )
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func loadPosts () {
        // причитали из стораджа в битах
        if let postsDataBits = NSUserDefaults.standardUserDefaults().objectForKey (KEY_POSTS_IN_STORAGE) as? NSData {
            // перевели из битов в текст
           if let postsArray = NSKeyedUnarchiver.unarchiveObjectWithData (postsDataBits) as? [Post] {
                _loadedPosts = postsArray
            }
        }
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "postsLoaded", object: nil))
        
    }
    
    func saveImageAndCreatePath (image: UIImage) ->String {
        let imageData = UIImagePNGRepresentation(image)
        let imagePath = "image\(NSDate.timeIntervalSinceReferenceDate()).png"
        let fullPath = documentsPathForFileName(imagePath)
        imageData?.writeToFile(fullPath, atomically: true)
        return imagePath
    }
    
    func imageForPath (path:String) -> UIImage? {
        let fullPath =  documentsPathForFileName(path)
        let image = UIImage(named: fullPath)
        return image
    }
    
    func imageForPath(path: String) {
        
    }
    
    func addPost (post: Post) {
        print(_loadedPosts.count)
        _loadedPosts.append(post)
        print(_loadedPosts.count)
        
        savePosts()
        loadPosts()
        
    }
    
    func documentsPathForFileName(name:String) ->String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) //Array
        let fullPath = paths[0] as NSString
        return fullPath.stringByAppendingPathComponent(name)
    }
    
}