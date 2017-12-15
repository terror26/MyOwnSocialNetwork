//
//  ProfileVC.swift
//  MyOwnSocialNetwork
//
//  Created by Kanishk Verma on 15/12/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var userNameLbl: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    
    var ref :DatabaseReference!
    var imageSelected = false
    var imagePicker:UIImagePickerController!
    var addImage:UIImage!
    var imageurl:String!
    var name:String!
    
    var post:PostCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            print("snapshot value is \(snapshot.value)")
            
            if let value = snapshot.value as?NSDictionary {
                
                self.post = PostCell()
                
                self.imageurl = value["ProfileImg"] as?String
                print("image url is \(self.imageurl)")
                self.name = value["name"] as?String
                if self.imageurl != nil ,self.name != nil {
                
                self.configureProfile(imageurl: self.imageurl!,name: self.name as! String)
                
                }
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }


    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    
    //TO pick the image and then disiss the picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageSelected = true
            self.addImage = pickedImage
            
        }
        
        profileImg.image = addImage
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    
    @IBAction func updateBtnPressed(_ sender: Any) {
        guard let name = userNameLbl.text ,name != "" else {
            return
        }
        
        guard let image = addImage ,imageSelected == true else {
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(addImage, 0.2) {
            let imageUID = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imageUID).putData(imageData, metadata: metaData, completion: { (metaData, error) in
                if error != nil {
                    print("++++++++++++++++++++++++++ Unable to upload image to firebase Storage++++++++++++++")
                } else {
                    print("++++++++++++++++++++++++++Succesfully uploaded image ot the firebase++++++++++++++++++++")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    self.postToFirebase(imageUrl: downloadURL!)
                    
                }
            })
        }
    }
    
    func postToFirebase(imageUrl:String) {
        
        let post:Dictionary<String,AnyObject> = [
            "name": userNameLbl.text as AnyObject,
            "ProfileImg": imageUrl as AnyObject,
            ]
        
        let Firebasepost = DataService.ds.REF_USER_CURRENT
        
        Firebasepost.setValue(post)
    }
    
    func configureProfile(imageurl:String,name:String) {
        
        
        let ref = Storage.storage().reference(forURL: imageurl)
        ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
            if error != nil {
                print("JESS: Unable to download image from Firebase storage")
            } else {
                print("JESS: Image downloaded from Firebase storage")
                
                if let imgData = data {
                    
                    if let img = UIImage(data: imgData) {
                        
                        self.profileImg.image = img
                        FeedVC.imageCache.setObject(img, forKey: imageurl as NSString)

                    }
                }
            }
        })
        
    self.userNameLbl.text = name
    }
    
}




















