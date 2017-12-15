//
//  DataServices.swift
//  MyOwnSocialNetwork
//
//  Created by Kanishk Verma on 08/12/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    static let ds = DataService()
    
    //Database referenceing
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    
    //Storage Referencing
    private var _REF_POST_IMAGE = STORAGE_BASE.child("postsPicks")
    
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }

    var REF_USERS:DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER :DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT :DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USER.child(uid!)
        return user
    }
    
    
    
    var REF_POST_IMAGES :StorageReference {
        return _REF_POST_IMAGE
    }
    
    func createFirebaseDBUser(id:String,userData: Dictionary<String,String>) {
        
        REF_USERS.child(id).updateChildValues(userData)
        
    }
    
    
}
