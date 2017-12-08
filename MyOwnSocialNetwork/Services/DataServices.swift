//
//  DataServices.swift
//  MyOwnSocialNetwork
//
//  Created by Kanishk Verma on 08/12/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS:DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER :DatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(id:String,userData: Dictionary<String,String>) {
        
        REF_USERS.child(id).updateChildValues(userData)
        
    }
    
    
}
