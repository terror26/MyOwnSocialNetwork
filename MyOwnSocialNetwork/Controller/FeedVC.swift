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
import GoogleSignIn

class FeedVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GIDSignInUIDelegate {

    @IBOutlet weak var addImage: CircleView!
    @IBOutlet weak var tableview :UITableView!
    @IBOutlet weak var captionText: UITextField!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var Posts = [Post]()
    var imagePicker:UIImagePickerController!
    var imageSelected  = false
    var ProfileImgUrl:String!
    var name:String!
    var ref:DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        ProfileImgUrl = ""
        name = ""
        ref = Database.database().reference()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                self.Posts = [] // THIS IS THE NEW LINE

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
        
        //Current user stuff
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let snap = snapshot.value as?NSDictionary {
                print("+++++++++++++Ramram+++++++++++++")
                self.ProfileImgUrl = snap["ProfileImg"] as?String
                self.name = snap["name"] as? String
                
                print("+++++++++++The name from users to the post is \(self.ProfileImgUrl)\(self.name)+++++++++++++++")
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
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
            
            if let image = FeedVC.imageCache.object(forKey: post.imageurl as NSString),let profileimg = FeedVC.imageCache.object(forKey: post.Profileimageurl as NSString)  {
        
                print("###############Before updating the profile  image url is \(self.ProfileImgUrl) ############")
               cell.configureTableCell(post: post, img: image, Name: self.name, imageUrl: post.imageurl, profileimg: profileimg, profileImgUrl: post.Profileimageurl)
                
                
                return cell
            } else {
                
                print("++++++++++++++++++ Before updating the profile  image url is \(post.Profileimageurl) +++++++++++++++")
                print("++++++++++++++++++ Before updatingh the imageurl is \(post.imageurl)")
                 cell.configureTableCell(post: post, img: nil, Name: self.name, imageUrl: post.imageurl, profileimg: nil, profileImgUrl: post.Profileimageurl)
                
                return cell
            }
        } else {
            return PostCell()
        }
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
        

        
   
        print("the profile name and the url of the image associated with that is \(self.name) \(self.ProfileImgUrl)")
        
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
                    self.postToFirebase(imageUrl: downloadURL!,ProfileImg: self.ProfileImgUrl ,name: self.name)
                    
                }
            })
        }
    }
    
    func postToFirebase(imageUrl:String,ProfileImg:String , name:String) {
        
        print("the name and the profileimg is \(ProfileImg)\(name)")
        
        let post:Dictionary<String,AnyObject> = [
        
            "caption": captionText.text as AnyObject,
            "imageUrl": imageUrl as AnyObject,
            "likes": 0 as AnyObject,
            "PostedBy": name as AnyObject,
            "ProfileImg" : ProfileImg as AnyObject
        
        ]
        
        
        
        let Firebasepost = DataService.ds.REF_POSTS.childByAutoId()
        Firebasepost.setValue(post)
        captionText.text = ""
        addImage.image = UIImage(named: "add-image")
        imageSelected = false
        tableview.reloadData()
        
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func SignoutTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
        
        
    }
   
    @IBAction func ProfileBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToProfile", sender: nil)
    
    }
    
   
    
    
    
}












