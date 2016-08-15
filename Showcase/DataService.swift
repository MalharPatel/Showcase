//
//  DataService.swift
//  Showcase
//
//  Created by Malhar Patel on 8/14/16.
//  Copyright © 2016 Malhar Patel. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://showcase-4c377.firebaseio.com"

class DataService {
    static let ds = DataService()
    private var _REF_BASE = FIRDatabase.database().reference()
    private var _REF_POSTS = FIRDatabase.database().referenceFromURL("\(URL_BASE)/posts")
    private var _REF_USERS = FIRDatabase.database().referenceFromURL("\(URL_BASE)/users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
//    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
//        REF_USERS.child(uid).setValue(user)
//    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = FIRDatabase.database().referenceFromURL("\(URL_BASE)").child("users").child(uid)
        return user
    }
    
    
}