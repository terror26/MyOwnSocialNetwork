//
//  PostCell.swift
//  MyOwnSocialNetwork
//
//  Created by Kanishk Verma on 07/12/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg : UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var likeImage:UIImageView!
    
    
    var post:Post!
    var likeRef:DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
    }
    
    func configureTableCell(post:Post, img:UIImage? = nil) {
        
        self.post = post
        likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        self.caption.text = post.caption
        self.likeLbl.text = "\(post.likes)"
        
        if img != nil {
            
            self.postImg.image = img

        } else {
            
            let ref = Storage.storage().reference(forURL: post.imageurl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("JESS: Unable to download image from Firebase storage")
                } else {
                    print("JESS: Image downloaded from Firebase storage")
                    
                    if let imgData = data {
                    
                        if let img = UIImage(data: imgData) {
                        
                            self.postImg.image = img
                            
                            FeedVC.imageCache.setObject(img, forKey: post.imageurl as NSString)
                        }
                    }
                }
            })
        }
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "empty-heart")
            } else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    @objc func likeTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.addLikes(addLike: true)
                self.likeRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.addLikes(addLike: false)
                self.likeRef.removeValue()
            }
        })
    }
}






















