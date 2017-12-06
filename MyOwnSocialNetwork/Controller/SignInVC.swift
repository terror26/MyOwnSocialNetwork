//
//  ViewController.swift
//  MyOwnSocialNetwork
//
//  Created by Kanishk Verma on 04/12/17.
//  Copyright © 2017 Kanishk Verma. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func facebookBtnPressed(_ sender: AnyObject) {
    
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self){
            (result,error) in
            if error != nil {
                print("++++++++++++++++++Not Able To authenticate with the facebook+++++++++++")
            } else if result?.isCancelled == true {
                print("+++++++++++++USer Cancelled the Facebook Authentication++++++++++++++++")
            } else {
                print("+++++++++++++++++++++++++++++++Authenticated Successfully++++++++++++++")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.FirebaseAuth(credential)
            }
        }
    }
    
    func FirebaseAuth(_ credential:AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("++++++++++++++++Firebase Authentication Error++++++++++++")
            } else {
                print("Authentication completed with Firebase")
            }
            })
    }
}












