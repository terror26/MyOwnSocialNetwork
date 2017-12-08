//
//  Post.swift
//  MyOwnSocialNetwork
//
//  Created by Kanishk Verma on 08/12/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//

import Foundation

class Post {
    private var _caption:String!
    private var _imageurl:String!
    private var _likes :Int!
    private var _postKey:String!

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
    
    init(caption:String ,Imageurl:String ,likes:Int ) {
        self._caption = caption
        self._imageurl = Imageurl
        self._likes = likes
    }
    
    init(postKey: String, postData:Dictionary<String, AnyObject> ) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as?String {
            self._caption = caption
        }
        
        if let imageurl = postData["imageUrl"] as?String{
            self._imageurl = imageurl
        }
        
        if let likes = postData["likes"] as?Int {
            self._likes = likes
        }
        
    }
    
}

















