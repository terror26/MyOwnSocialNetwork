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
    @IBOutlet weak var captionText: UITextField!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var Posts = [Post]()
    var imagePicker:UIImagePickerController!
    var imageSelected  = false
    
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
            imageSelected = true
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBtnPressed(_ sender: Any) {
        
        guard let caption = captionText.text ,caption != "" else {
            print("++++++++++++++CaptionMust be Entered++++++++++")
            return
        }
        
        guard let image = addImage.image, imageSelected == true else {
            print("++++++++++++image must be selected++++++++")
            return
        }
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUID = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imageUID).putData(imageData, metadata: metaData, completion: { (metaData, error) in
                if error != nil {
                    print("++++++++++++++++++++++++++ Unable to upload image to firebase Storage++++++++++++++")
                } else {
                    print("++++++++++++++++++++++++++Succesfully uploaded image ot the firebase++++++++++++++++++++")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    
                }
                })
            
            
        }
        
        
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
}












