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
    
    var post:Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureTableCell(post:Post, img:UIImage? = nil) {
        self.post = post
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
    }

}






















