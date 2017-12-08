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
class FeedVC: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview :UITableView!
    var Posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
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
        
        let post = Posts[indexPath.row]
        print("Yo\(post.caption)")
        
        return tableview.dequeueReusableCell(withIdentifier: "PostCell") as!PostCell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignoutTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    


}












