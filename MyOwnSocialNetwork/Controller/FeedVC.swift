//
//  FeedVCViewController.swift
//  MyOwnSocialNetwork
//
//  Created by Kanishk Verma on 07/12/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
class FeedVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var addImage: CircleView!
    @IBOutlet weak var tableview :UITableView!
    

    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var Posts = [Post]()
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots {
                    if let postDict = snap.value as? Dictionary<String , AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.Posts.append(post)
                    }
                }
            }
            self.tableview.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableview.dequeueReusableCell(withIdentifier: "PostCell") as?PostCell {
            
            let post = Posts[indexPath.row]
            
            if let image = FeedVC.imageCache.object(forKey: post.imageurl as NSString) {
            
                cell.configureTableCell(post: post,img: image)
                return cell
            } else {
                
                cell.configureTableCell(post: post,img: nil)
                return cell
            }
        } else {
            return PostCell()
        }
    }

    
    @IBAction func SignoutTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = pickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
}












