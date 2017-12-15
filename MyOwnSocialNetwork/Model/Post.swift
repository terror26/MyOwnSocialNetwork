//
//  Post.swift
//  MyOwnSocialNetwork
//
//  Created by Kanishk Verma on 08/12/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _caption:String!
    private var _imageurl:String!
    private var _likes :Int!
    private var _postKey:String!
    private var _postRef:DatabaseReference!
    private var _profileimageurl:String!
    private var _name:String!
    

    var caption: String {
        return _caption
    }
    
    var imageurl: String {
        return _imageurl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    var Name:String {
        return _name
    }
    
    var Profileimageurl:String {
        return _profileimageurl
    }
    
    init(caption:String ,Imageurl:String ,likes:Int) {
        self._caption = caption
        self._imageurl = Imageurl
        self._likes = likes
        self._profileimageurl = ""
    }
    
    init(postKey: String, postData:Dictionary<String, AnyObject> ) {
        self._postKey = postKey
        self._profileimageurl = ""
        if let caption = postData["caption"] as?String {
            self._caption = caption
        }
        
        if let imageurl = postData["imageUrl"] as?String{
            self._imageurl = imageurl
        }
        
        if let likes = postData["likes"] as?Int {
            self._likes = likes
        }
        
        if let name = postData["PostedBy"] as?String {
            self._name = name
        }
        print("The data in the url of the post is\(imageurl)")
        print("the data in the profile imageURl is \(Profileimageurl)")
        
        
        if let profileImageUrl = postData["ProfileImg"] as?String {
            self._profileimageurl = profileImageUrl
        }
        
        
        _postRef = DataService.ds.REF_POSTS.child(postKey)
    }
    
    func addLikes(addLike:Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes-1
        }
        _postRef.child("likes").setValue(_likes)
    }
}

















