//
//  Post.swift
//  Showcase
//
//  Created by Malhar Patel on 8/16/16.
//  Copyright © 2016 Malhar Patel. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _postDesc: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var postDesc: String {
        return _postDesc
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(description: String, imageUrl: String?, username: String) {
        self._postDesc = description
        self._imageUrl = imageUrl
        self._username = username
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDesc = desc
        }
        
        self._postRef = DataService.ds.REF_POSTS.child(self._postKey)
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}